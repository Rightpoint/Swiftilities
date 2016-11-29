//
//  MathHelpers.swift
//  Swiftilities
//
//  Created by John Stricker on 5/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public extension Comparable {

    /// Clamp a value to a `ClosedInterval`.
    ///
    /// - Parameter to: a `ClosedInterval` whose start and end specify the clamp's minimum and maximum.
    /// - Returns: the clamped value.
    func clamped(to: ClosedRange<Self>) -> Self {
        return clamped(min: to.lowerBound, max: to.upperBound)
    }

    /// Clamp a value to a minimum and maximum value.
    ///
    /// - Parameters:
    ///   - lower: the minimum value allowed.
    ///   - upper: the maximum value allowed.
    /// - Returns: the clamped value.
    func clamped(min lower: Self, max upper: Self) -> Self {
        return min(max(self, lower), upper)
    }

}
