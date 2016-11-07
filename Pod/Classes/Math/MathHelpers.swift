//
//  MathHelpers.swift
//  Swiftilities
//
//  Created by John Stricker on 5/3/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
