//
//  Double+Scale.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/15/16.
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

public extension Double {
    /**
     Re-maps a number from one range to another.

     - parameter from:  The range to interpret the number as being a part of.
     - parameter to:    The range to map the number to.
     - parameter clamp: Whether the result should be clamped to the `to` range.

     - returns: The input number, scaled from the `from` range to the `to` range.
     */
    func scale(from: ClosedRange<Double>, to: ClosedRange<Double>, clamp: Bool = false) -> Double {
        guard from != to else {
            return self // short circuit the math if they're equal
        }
        var result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        if clamp {
            result = max(min(result, to.upperBound), to.lowerBound)
        }
        return result
    }
}
