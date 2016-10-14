//
//  UIView+KeyboardLayoutGuide.swift
//  Swiftilities
//
//  Created by Rob Visentin on 2/8/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/


import UIKit

/**
 *  A UIView extension that exposes the keyboard frame as a layout guide (UILayoutGuide).
 */
public extension UIView {

    private class KeyboardLayoutGuide : UILayoutGuide {}

    /// A layout guide for the keyboard
    var keyboardLayoutGuide: UILayoutGuide? {
        #if swift(>=3.0)
        if let existingIdx = layoutGuides.index(where: { $0 is KeyboardLayoutGuide }) {
            return layoutGuides[existingIdx]
        }
        #else
            if let existingIdx = layoutGuides.indexOf({ $0 is KeyboardLayoutGuide }) {
                return layoutGuides[existingIdx]
            }
        #endif
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

        #if swift(>=3.0)
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
        #else
            guide.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
            guide.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
            guide.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true

            let topConstraint = guide.topAnchor.constraintEqualToAnchor(bottomAnchor)
            topConstraint.active = true

            Keyboard.addFrameObserver(guide) { [weak self] keyboardFrame in
                if let sself = self where sself.window != nil {
                    var frameInWindow = sself.frame

                    if let superview = sself.superview {
                        frameInWindow = superview.convertRect(sself.frame, toView: nil)
                    }

                    topConstraint.constant = min(0.0, -(frameInWindow.maxY - keyboardFrame.minY))
                    
                    sself.layoutIfNeeded()
                }
            }
        #endif
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
