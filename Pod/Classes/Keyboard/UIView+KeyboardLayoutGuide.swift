//
//  UIView+KeyboardLayoutGuide.swift
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

    fileprivate class KeyboardLayoutGuide : UILayoutGuide {}

    /// A layout guide for the keyboard
    var keyboardLayoutGuide: UILayoutGuide? {
        if let existingIdx = layoutGuides.index(where: { $0 is KeyboardLayoutGuide }) {
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

        guide.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        guide.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        guide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let topConstraint = guide.topAnchor.constraint(equalTo: bottomAnchor)
        topConstraint.isActive = true

        Keyboard.addFrameObserver(guide) { [weak self] keyboardFrame in
            if let sself = self , sself.window != nil {
                var frameInWindow = sself.frame

                if let superview = sself.superview {
                    frameInWindow = superview.convert(sself.frame, to: nil)
                }

                topConstraint.constant = min(0.0, -(frameInWindow.maxY - keyboardFrame.minY))

                sself.layoutIfNeeded()
            }
        }
        
        return guide
    }

    /**
     Remove the keyboard layout guide. NOTE: you do not need to invoke this method, it is purely optional.
     */
    func removeKeyboardLayoutGuide() {
        if let keyboardLayoutGuide = keyboardLayoutGuide {
            Keyboard.removeFrameObserver(keyboardLayoutGuide)
            removeLayoutGuide(keyboardLayoutGuide)
        }
    }

}
