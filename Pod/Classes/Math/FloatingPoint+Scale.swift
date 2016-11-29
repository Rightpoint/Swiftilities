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
    func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamp: Bool = false) -> Self {
        guard source != destination else {
            return self // short circuit the math if they're equal
        }
        var result = ((self - source.lowerBound) / (source.upperBound - source.lowerBound)) * (destination.upperBound - destination.lowerBound) + destination.lowerBound
        if clamp {
            result = result.clamped(to: destination)
        }
        return result
    }

}
