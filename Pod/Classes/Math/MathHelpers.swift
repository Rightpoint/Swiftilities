//
//  MathHelpers.swift
//  Swiftilities
//
//  Created by John Stricker on 5/3/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/

import Foundation

public struct MathHelpers {

    #if swift(>=3.0)
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
    #else
    /**
     Clamp a value to a ClosedInterval

     - parameter value: the value to be clamped
     - parameter to:    a ClosedInterval whose start and end specify the clamp's minimum and maximum

     - returns: the clamped value
     */
    static func clamp<T: Comparable>(value: T, to: ClosedInterval<T>) -> T {
        return clamp(value, min: to.start, max: to.end)
    }

    /**
     Clamp a value to a minimum and maximum value.

     - parameter value: the value to be clamped
     - parameter min: the minimum value allowed
     - parameter max: the maximzum value allowed

     - returns: the clamped value
     */
    static func clamp<T: Comparable>(value: T, min lower: T, max upper: T) -> T {
        return min(max(value, lower), upper)
    }
    #endif

}
