//
//  UIColor+Helpers.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/14/16.
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

import UIKit

public extension UIColor {

    public convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = UInt8((hex & 0xFF0000) >> 16)
        let g = UInt8((hex & 0xFF00) >> 8)
        let b = UInt8(hex & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: alpha)
    }

    public convenience init(rgba: UInt32) {
        let r = UInt8((rgba & 0xFF000000) >> 24)
        let g = UInt8((rgba & 0xFF0000) >> 16)
        let b = UInt8((rgba & 0xFF00) >> 8)
        let a = UInt8(rgba & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: CGFloat(a) / 255)
    }

    public convenience init(red8: UInt8, green8: UInt8, blue8: UInt8, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red8) / 255.0, green: CGFloat(green8) / 255.0, blue: CGFloat(blue8) / 255.0, alpha: alpha)
    }

}
