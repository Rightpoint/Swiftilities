//
//  FloatingPoint+Scale.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public extension FloatingPoint {

    /// Re-maps a number from one range to another.
    ///
    /// - Parameters:
    ///   - source: The range to interpret the number as being a part of.
    ///   - destination: The range to map the number to.
    ///   - clamp: Whether the result should be clamped to the `to` range.
    /// - Returns: The input number, scaled from the `from` range to the `to` range.
    public func scaled<T: AnyClosedRange, U: AnyClosedRange>(from source: T, to destination: U, clamp: Bool = false) -> Self where T.Bound == Self, U.Bound == Self {
        // these are broken up to speed up compile time
        let selfMinusLower = self - source.start
        let sourceUpperMinusLower = source.end - source.start
        let destinationUpperMinusLower = destination.end - destination.start
        var result = (selfMinusLower / sourceUpperMinusLower) * destinationUpperMinusLower + destination.start
        if clamp {
            result = result.clamped(to: destination)
        }
        return result
    }

}
