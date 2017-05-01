//
//  RingBufferTests.swift
//  Swiftilities
//
//  Created by Adam Tierney on 3/6/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation
import XCTest
import Swiftilities

class RingBufferTests: XCTestCase {

    private func newRingBuffer(size: Int) -> UnsafeMutableRingBufferPointer<UInt8> {
        let queueBaseAddress = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        queueBaseAddress.initialize(to: 0, count: size)
        return UnsafeMutableRingBufferPointer(baseAddress: queueBaseAddress,
                                              count: size)
    }

    func testBaseState() {
        var rb = newRingBuffer(size: 8)

        XCTAssertEqual(rb.regionSize, 8)

        var nums: [UInt8] = [1, 2, 3, 4]
        rb.enqueueData(start: &nums, count: 4)

        XCTAssertEqual(rb[0], 1)
        XCTAssertEqual(rb[1], 2)
        XCTAssertEqual(rb[2], 3)
        XCTAssertEqual(rb[3], 4)
        XCTAssertEqual(rb.count, 4)

        rb.cleanUp()
    }

    func testStateProperties() {
        let size = 50
        var rb = newRingBuffer(size: size)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]

        XCTAssertEqual(rb.usedSpace, 0)

        // inital state
        XCTAssertTrue(rb.isEmpty)
        XCTAssertEqual(rb.freeSpace, size)
        XCTAssertEqual(rb.usedSpace, 0)

        rb.enqueueData(start: &nums, count: 8)
        XCTAssertEqual(rb.usedSpace, 8)
        XCTAssertEqual(rb.freeSpace, 42)

        // remove
        rb.removeData(count: 3)
        XCTAssertEqual(rb.usedSpace, 5)

        rb.enqueueData(start: &nums, count: 8)
        XCTAssertEqual(rb.usedSpace, 13)
        XCTAssertEqual(rb.freeSpace, 37)

        // fill and overwrite
        for _ in 0..<5 {
            rb.enqueueData(start: &nums, count: 8)
        }
        XCTAssertEqual(rb.usedSpace, size)
        XCTAssertEqual(rb.freeSpace, 0)

        // remove
        rb.removeData(count: 24)
        XCTAssertEqual(rb.usedSpace, 26)
        XCTAssertEqual(rb.freeSpace, 24)

        // reset
        rb.resetBuffer()
        XCTAssertEqual(rb.usedSpace, 0)
        XCTAssertEqual(rb.freeSpace, size)

        rb.cleanUp()
    }

    func testBasicDequeue() {
        var rb = newRingBuffer(size: 8)
        var nums: [UInt8] = [1, 2, 3, 4]

        rb.enqueueData(start: &nums, count: 4)
        let dequeued = rb.dequeueData(count: 2)

        XCTAssertEqual(rb[0], 3)
        XCTAssertEqual(rb[1], 4)
        XCTAssertEqual(rb.count, 2)

        XCTAssertEqual(dequeued[0], 1)
        XCTAssertEqual(dequeued[1], 2)

        rb.cleanUp()
        dequeued.baseAddress?.deinitialize(count: dequeued.count)
        dequeued.baseAddress?.deallocate(capacity: dequeued.count)
    }

    func testDequeueAll() {
        var rb = newRingBuffer(size: 20)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]

        rb.enqueueData(start: &nums, count: 5)
        rb.enqueueData(start: &nums, count: 8)
        rb.enqueueData(start: &nums, count: 3)

        let dequeued = rb.dequeueAll()

        let expectation: [UInt8] = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3]

        let arrValue = Array(dequeued)
        XCTAssertEqual(arrValue, expectation)

        rb.cleanUp()
        dequeued.baseAddress?.deinitialize(count: dequeued.count)
        dequeued.baseAddress?.deallocate(capacity: dequeued.count)
    }

    func testIteration() {
        var rb = newRingBuffer(size: 20)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        let expectation: [UInt8] = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3]

        rb.enqueueData(start: &nums, count: 5)
        rb.enqueueData(start: &nums, count: 8)
        rb.enqueueData(start: &nums, count: 3)

        for (idx, itm) in rb.enumerated() {
            XCTAssertEqual(expectation[idx], itm)
        }

        rb.cleanUp()
    }

    func testEnqueueSafteyCheck() {
        var rb = newRingBuffer(size: 8)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        var moreNums: [UInt8] = [9, 10, 11]
        rb.enqueueData(start: &nums, count: 8)

        var e: Error? = nil
        do {
            try rb.safelyEnqueueData(start: &moreNums, count: 3)
        }
        catch {
            e = error
        }

        XCTAssertNotNil(e)
        XCTAssertEqual(rb[0], 1)
        XCTAssertEqual(rb[7], 8)
        XCTAssertEqual(rb.count, 8)

        rb.cleanUp()
    }

    func testEnqueueOverwrite() {
        var rb = newRingBuffer(size: 8)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        var moreNums: [UInt8] = [9, 10, 11]

        rb.enqueueData(start: &nums, count: 8)
        rb.enqueueData(start: &moreNums, count: 3)

        // buffer should overwrite first 3 values but treat them as appended
        // leaving index 0 -> 4 and the last index 11
        XCTAssertEqual(rb[0], 4)
        XCTAssertEqual(rb[1], 5)
        XCTAssertEqual(rb[5], 9)
        XCTAssertEqual(rb[6], 10)
        XCTAssertEqual(rb[7], 11)
        XCTAssertEqual(rb.count, 8)

        rb.cleanUp()
    }

    func testManipulateSubrange() {
        var rb = newRingBuffer(size: 8)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]

        rb.enqueueData(start: &nums, count: 8)

        let range = Range<Int>(2...5)
        var subrange = rb[range]
        XCTAssertEqual(subrange.count, 4)
        XCTAssertEqual(subrange[2], 3)
        XCTAssertEqual(subrange[3], 4)
        XCTAssertEqual(subrange[4], 5)
        XCTAssertEqual(subrange[5], 6)

        subrange[3] = 99
        subrange[4] = 100

        XCTAssertEqual(rb[3], 99)
        XCTAssertEqual(rb[4], 100)

        rb.cleanUp()
    }

    func testSettableSubrange() {
        var rb = newRingBuffer(size: 8)
        var nums: [UInt8] = [1, 2, 3, 4, 5, 6, 7, 8]
        rb.enqueueData(start: &nums, count: 8)

        var otherRB = newRingBuffer(size: 5)
        var otherNums: [UInt8] = [66, 67, 68, 69, 70]
        otherRB.enqueueData(start: &otherNums, count: 5)

        let subrange = otherRB[0...4]

        rb[2...6] = subrange

        XCTAssertEqual(rb[1], 2)
        XCTAssertEqual(rb[2], 66)
        XCTAssertEqual(rb[3], 67)
        XCTAssertEqual(rb[4], 68)
        XCTAssertEqual(rb[5], 69)
        XCTAssertEqual(rb[6], 70)
        XCTAssertEqual(rb[7], 8)

        rb.cleanUp()
        otherRB.cleanUp()
    }
}
