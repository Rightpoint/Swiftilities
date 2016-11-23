//
//  MathHelpers.swift
//  Swiftilities
//
//  Created by John Stricker on 5/3/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct MathHelpers {

    /**
     Clamp a value to a ClosedInterval

     - parameter value: the value to be clamped
     - parameter to:    a ClosedInterval whose start and end specify the clamp's minimum and maximum

     - returns: the clamped value
     */
    static func clamp<T: Comparable>(_ value: T, to: ClosedRange<T>) -> T {
        return clamp(value, min: to.lowerBound, max: to.upperBound)
    }

    /**
     Clamp a value to a minimum and maximum value.

     - parameter value: the value to be clamped
     - parameter min: the minimum value allowed
     - parameter max: the maximzum value allowed

     - returns: the clamped value
     */
    static func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
        return min(max(value, lower), upper)
    }

}
