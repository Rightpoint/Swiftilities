//
//  Integer+Random.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 7/25/16.
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

public extension IntegerType {
    /**
     Generate a random integer using random data from arc4random_buf.
     `man arc4random_buf` for specifics about the generation of random data.

     - returns: a random integer
     */
    static func random() -> Self {
        var randomInt: Self = 0
        arc4random_buf(&randomInt, sizeofValue(randomInt))
        return randomInt
    }
}

public extension SignedIntegerType {
    /**
     Generate a random signed integer between specific boundaries

     - parameter min: the minimum value allowed, defaults to 0
     - parameter max: the maximum value allowed

     - returns: a bounded random signed integer
     */
    static func random(min: Self = 0, max: Self) -> Self {
        let difference = (max - min) + Self(1)
        return abs(random() % difference) + min
    }
}

public extension UnsignedIntegerType {
    /**
     Generate a random integer between specific boundaries

     - parameter min: the minimum value allowed, defaults to 0
     - parameter max: the maximum value allowed

     - returns: a bounded random unsigned integer
     */
    static func random(min: Self = 0, max: Self) -> Self {
        let difference = (max - min) + Self(1)
        return (random() % difference) + min
    }
}
