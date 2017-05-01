//
//  UnsafeMutableRingBufferPointer.swift
//  Swiftilities
//
//  Created by Adam Tierney on 3/6/17.
//
//

/// A non-owning collection wrapping a contiguous region of memory. The ring buffer exposes an
/// interface for infinitely queuing and dequing data. The buffer treats the memory as if it were a
/// ring, overwriting from the head of the buffer when there is no more space available.
public struct UnsafeMutableRingBufferPointer<Element>: MutableCollection, RandomAccessCollection {

    public typealias Index = Int
    public typealias Indices = DefaultRandomAccessIndices<UnsafeMutableRingBufferPointer<Element>>

    public var startIndex: Index = 0

    public var endIndex: Index {
        return startIndex.advanced(by: usedSpace)
    }

    /// the base address of the underlying buffer
    public var baseAddress: UnsafeMutablePointer<Element>? {
        return buffer.baseAddress
    }

    /// the size of the underlying buffer
    public var regionSize: Int {
        return buffer.count
    }

    /// number of element sized words used
    public var usedSpace: Int {
        if tail < head {
            // tail lags head
            return bufferCount - (head - tail) + 1
        }
        else if tail > head {
            // head lags tail
            return tail - head + 1
        }
        else {
            // tail == head, empty case
            return 0
        }
    }

    /// number of element sized words available before overwrite
    public var freeSpace: Int {
        return bufferCount - usedSpace
    }

    /// length of number of items, == to usedSpace
    public var count: Int {
        return usedSpace
    }

    // MARK: -

    private var buffer: UnsafeMutableBufferPointer<Element>

    /// points to the first valid index
    private var head: Int = 0

    /// points to the last valid index
    private var tail: Int = 0

    /// count of the underlying buffer
    private var bufferCount: Int {
        return buffer.count
    }

    // MARK: -

    //swiftlint:disable:next variable_name
    public func index(after i: Index) -> Index {
        guard i + 1 < endIndex else {
            return endIndex
        }
        return i + 1
    }

    //swiftlint:disable:next variable_name
    public func index(before i: Index) -> Index {
        guard i - 1 > startIndex else {
            return startIndex
        }
        return i - 1
    }

    public func makeIterator() -> RingBufferIterator<Element> {
        return RingBufferIterator(ringBuffer: self)
    }

    public subscript(index: Index) -> Element {
        get {
            let range = startIndex..<endIndex
            guard range.contains(index) else { fatalError("index out of range") }
            return buffer[circularIndex(index)]
        }
        set(newValue) {
            let range = startIndex..<endIndex
            guard range.contains(index) else { fatalError("index out of range") }
            buffer[circularIndex(index)] = newValue
        }
    }

    public subscript(bounds: Range<Index>) ->
        MutableRandomAccessSlice<UnsafeMutableRingBufferPointer<Element>> {
        get {
            return MutableRandomAccessSlice(base: self, bounds: bounds)
        }

        set(newValue) {
            let adjustedIndex = circularIndex(bounds.lowerBound)
            let adjustedBounds = adjustedIndex..<adjustedIndex + bounds.count
            for i in 0..<adjustedBounds.count {
                let bufferIndex = adjustedBounds.startIndex.advanced(by: i)
                let newValueIndex = newValue.startIndex.advanced(by: i)
                buffer[bufferIndex] = newValue[newValueIndex]
            }
        }
    }

    /// This method copies the memory from the specified region onto the tail of the ring buffer.
    /// If the ring buffer is full it automatically begins overwriting from the head of the buffer.
    ///
    /// - parameters:
    ///    - start: the base address from which to start
    ///   - count: the length of the memory to copy into the ring buffer
    public mutating func enqueueData(start: UnsafeMutablePointer<Element>,
                                     count: Int) {

        guard count > 0 else { return }

        let willStartOverwriting = count > freeSpace

        guard let baseAddress = buffer.baseAddress else {
            fatalError("the backing buffer has no base address.")
        }

        // grow buffer by count:
        for i in 0..<count {

            if i != 0 || tail != head {
                // increment, except in empty case.
                tail = wrappingIncrement(tail, by: 1)
            }

            let ptr = baseAddress.advanced(by: tail)
            ptr.assign(from: start.advanced(by: i), count: 1)
        }

        if willStartOverwriting {
            head = wrappingIncrement(tail, by: 1)
        }
    }

    /// This method checks that the enqueued data will not overwrite any data before enqueuing the
    /// data. If the data is safe to write it enqueues the data otherwise it throws an error.
    ///
    /// - parameters:
    ///   - start: the base address from which to start
    ///         - count: the length of the memory to copy into the ring buffer
    ///
    /// - throws:
    ///   RingBufferError.unableToSafelyEnqueue
    public mutating func safelyEnqueueData(start: UnsafeMutablePointer<Element>,
                                           count: Int) throws {

        let willStartOverwriting = count > freeSpace
        guard !willStartOverwriting else {
            throw RingBufferError.unableToSafelyEnqueue
        }

        enqueueData(start: start, count: count)
    }

    /// Dequeues all Elements from the buffer and copies them into a new
    /// buffer. The caller is responsible for releaseing the data when it is no longer needed.
    ///
    /// - seealso: `dequeueData`
    ///
    /// - returns:
    /// the elements dequeued in a new, unmanaged buffer pointer
    public mutating func dequeueAll() -> UnsafeMutableBufferPointer<Element> {
        let count = usedSpace
        return dequeueData(count: count)
    }

    /// Dequeues `count` Element sized words from the head of the buffer and copies them into a new
    /// buffer. The caller is responsible for releaseing the data when it is no longer needed.
    ///
    /// - parameters:
    /// - count: The number of Element sized words to remove from the head of the buffer
    ///
    /// - returns:
    /// the elements dequeued in a new, unmanaged buffer pointer
    public mutating func dequeueData(count: Int) -> UnsafeMutableBufferPointer<Element> {

        guard count > 0 else {
            return UnsafeMutableBufferPointer<Element>(start: nil, count: 0)
        }

        guard let baseAddress = buffer.baseAddress else {
            fatalError("the backing buffer has no base address.")
        }

        let willEmpty = usedSpace - count == 0
        defer { tail = willEmpty ? head : tail }

        let returnAddress = UnsafeMutablePointer<Element>.allocate(capacity: count)
        for i in 0..<count {
            let ptr = returnAddress.advanced(by: i)
            ptr.initialize(to: baseAddress[head], count: 1)
            head = head + 1
            if head == bufferCount {
                head = 0
            }
        }

        return UnsafeMutableBufferPointer<Element>(start: returnAddress, count: count)
    }

    /// resets buffer to a empty state
    public mutating func resetBuffer() {
        head = 0
        tail = 0
    }

    /// Removes count Element sized words of data from the front of the buffer
    public mutating func removeData(count: Int) {
        guard count > 0 else { return }

        let willEmpty = usedSpace - count == 0
        defer { tail = willEmpty ? head : tail }

        head = wrappingIncrement(head, by: count)
    }

    // MARK: -

    /// An index based off of `head` which wraps instead of going out of bounds
    private func circularIndex(_ virtualIndex: Index) -> Index {
        return  wrappingIncrement(head, by: virtualIndex)
    }

    /// returns an value rebounded to be between the 0 and the buffer count (exclusive)
    private func wrappingIncrement(_ val: Int, by inc: Int) -> Int {

        var ret = val + inc
        if ret >= bufferCount {
            ret -= bufferCount
        }
        else if ret < 0 {
            ret += bufferCount
        }

        return ret
    }

    // MARK: -

    /// Creates a new ring buffer over the passed in memory region. It is the caller's
    /// responsibility to ensure the memory is allocated and initalized before using the ring
    /// to manipulate this memory.
    public init(baseAddress: UnsafeMutablePointer<Element>, count: Int) {
        buffer = UnsafeMutableBufferPointer(start: baseAddress, count: count)
    }
}

// MARK: -

extension UnsafeMutableRingBufferPointer {

    /// A convenience method for cleaning up after a ring buffer
    /// Deinitalizes and deallocates the memory viewed by the ring buffer.
    /// Do not use this method if you do not own the memory viewed by the buffer.
    ///
    /// - Precondition: The buffer backing the ring buffer allocated and is initialized.
    ///
    /// - Postcondition: The memory is deinitialized and deallcoated.
    public func cleanUp() {
        guard let baseAddress = baseAddress else {
            return
        }

        let size = usedSpace + freeSpace
        baseAddress.deinitialize(count: size)
        baseAddress.deallocate(capacity: size)
    }
}

enum RingBufferError: Error, CustomStringConvertible {
    case unableToSafelyEnqueue

    var description: String {
        switch self {
        case .unableToSafelyEnqueue:
            return "Buffer is full. Unable to safely enqueue data."
        }
    }
}

public struct RingBufferIterator<Element>: IteratorProtocol {
    private let ringBuffer: UnsafeMutableRingBufferPointer<Element>
    private var index: UnsafeMutableRingBufferPointer<Element>.Index

    public init(ringBuffer: UnsafeMutableRingBufferPointer<Element>) {
        self.ringBuffer = ringBuffer
        self.index = ringBuffer.startIndex
    }

    public mutating func next() -> Element? {
        guard !ringBuffer.isEmpty else {
            return nil
        }
        let range = ringBuffer.startIndex..<ringBuffer.endIndex
        guard range.contains(index) else {
            return nil
        }
        let result = ringBuffer[index]
        index = ringBuffer.index(after: index)
        return result
    }
}
