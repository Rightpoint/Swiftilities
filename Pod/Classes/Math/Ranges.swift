//
//  Ranges.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 5/14/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

/// An interval over a comparable type, from an upper bound down to, and
/// including, a lower bound. This type exists because the closed range operator
/// (`...`) requires that the lower bound come before the higher bound.
///
/// You get instances of `ReversedClosedRange` by using the `reversed` property
/// of a `ClosedRange`. There is no way to construct a `ReversedClosedRange` directly.
///
///     let reversedNormalRange = (0.0...1.0).reversed
///
public struct ReversedClosedRange<Bound> where Bound : Comparable {

    /// The upper bound. Always greater than `lowerBound`.
    public let upperBound: Bound

    /// The lower bound. Always less than `upperBound`.
    public let lowerBound: Bound

    /// Returns a reversed closed range that contains both of its bounds.
    ///
    /// - Precondition: `upperBound` must be greater than `lowerBound`.
    /// - Parameters:
    ///   - upperBound: the upper bound for the range.
    ///   - lowerBound: the lower bound for the range.
    internal init(upperBound: Bound, lowerBound: Bound) {
        precondition(upperBound > lowerBound, "upperBound must be greater than lowerBound")

        self.upperBound = upperBound
        self.lowerBound = lowerBound
    }

}

public protocol AnyClosedRange: Equatable {

    associatedtype Bound: Comparable

    /// The start of the range.
    var start: Bound { get }

    /// The end of the range.
    var end: Bound { get }

    /// The lower bound. Always less than the upper bound.
    var lowerBound: Bound { get }

    /// The upper bound. Always greater than the lower bound.
    var upperBound: Bound { get }

}

extension AnyClosedRange {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return type(of: lhs) == type(of: rhs)
            && lhs.lowerBound == rhs.lowerBound
            && rhs.upperBound == lhs.upperBound
    }

}

extension ReversedClosedRange: AnyClosedRange {

    public var start: Bound {
        return upperBound
    }

    public var end: Bound {
        return lowerBound
    }

}

extension ClosedRange: AnyClosedRange {

    public var start: Bound {
        return lowerBound
    }

    public var end: Bound {
        return upperBound
    }

}

public extension ClosedRange {

    public var reversed: ReversedClosedRange<Bound> {
        return ReversedClosedRange(upperBound: upperBound, lowerBound: lowerBound)
    }

}
