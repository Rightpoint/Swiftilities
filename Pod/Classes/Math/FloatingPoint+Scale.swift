//
//  FloatingPoint+Scale.swift
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

public extension FloatingPoint {

    /// Re-maps a number from one range to another.
    ///
    /// - Parameters:
    ///   - source: The range to interpret the number as being a part of.
    ///   - destination: The range to map the number to.
    ///   - clamp: Whether the result should be clamped to the `to` range.
    /// - Returns: The input number, scaled from the `from` range to the `to` range.
    func scale(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamp: Bool = false) -> Self {
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
