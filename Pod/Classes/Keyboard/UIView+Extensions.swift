//
//  UIView+Extensions.swift
//  Swiftilities
//
//  Created by Rob Visentin on 2/8/16.
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

/**
 *  A UIView extension that exposes the keyboard frame as a layout guide (UILayoutGuide).
 */
public extension UIView {

    private class KeyboardLayoutGuide : UILayoutGuide {}

    /// A layout guide for the keyboard
    var keyboardLayoutGuide: UILayoutGuide? {
        if let existingIdx = layoutGuides.indexOf({ $0 is KeyboardLayoutGuide }) {
            return layoutGuides[existingIdx]
        }
        return nil
    }

    /**
     Add and configure a keyboard layout guide.
     
     - returns: A new keyboard layout guide or existing if previously invoked on this view
     */
    func addKeyboardLayoutGuide() -> UILayoutGuide {
        // Return the existing keyboard layout guide if one has already been added
        if let existingGuide = keyboardLayoutGuide {
            return existingGuide
        }

        let guide = KeyboardLayoutGuide()
        addLayoutGuide(guide)

        guide.leftAnchor.constraintEqualToAnchor(leftAnchor)
        guide.rightAnchor.constraintEqualToAnchor(rightAnchor)
        guide.bottomAnchor.constraintEqualToAnchor(bottomAnchor)

        let topConstraint = guide.topAnchor.constraintEqualToAnchor(bottomAnchor)

        Keyboard.addFrameObserver(guide) { [weak self] keyboardFrame in
            if let sself = self {
                let convertedFrame = sself.convertRect(keyboardFrame, fromView: nil)
                topConstraint.constant = -(UIScreen.mainScreen().bounds.maxY - convertedFrame.minY)

                sself.layoutIfNeeded()
            }
        }
        
        return guide
    }

    /**
     Remove the keyboard layout guide, must be called in deinit to ensure underlying keyboard frame
     handler is cancelled.
     */
    func removeKeyboardLayoutGuide() {
        if let keyboardLayoutGuide = keyboardLayoutGuide {
            Keyboard.removeFrameObserver(keyboardLayoutGuide)
            removeLayoutGuide(keyboardLayoutGuide)
        }
    }

}
