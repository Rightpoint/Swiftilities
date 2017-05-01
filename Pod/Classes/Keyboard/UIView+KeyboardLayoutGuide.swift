//
//  UIView+KeyboardLayoutGuide.swift
//  Swiftilities
//
//  Created by Rob Visentin on 2/8/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/**
 *  A UIView extension that exposes the keyboard frame as a layout guide (UILayoutGuide).
 */
public extension UIView {

    fileprivate class KeyboardLayoutGuide: UILayoutGuide {}

    /// A layout guide for the keyboard
    @nonobjc var keyboardLayoutGuide: UILayoutGuide? {
        if let existingIdx = layoutGuides.index(where: { $0 is KeyboardLayoutGuide }) {
            return layoutGuides[existingIdx]
        }
        return nil
    }

    @nonobjc var transitionCoordinator: UIViewControllerTransitionCoordinator? {
        var responder: UIResponder? = next
        while responder != nil {
            if let coordinator = (responder as? UIViewController)?.transitionCoordinator {
                return coordinator
            }
            responder = responder?.next
        }
        return nil
    }

    /**
     Add and configure a keyboard layout guide.

     - returns: A new keyboard layout guide or existing if previously invoked on this view
     */
    @nonobjc func addKeyboardLayoutGuide() -> UILayoutGuide {
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
            if let sself = self, sself.window != nil {
                var frameInWindow = sself.frame

                if let superview = sself.superview {
                    frameInWindow = superview.convert(sself.frame, to: nil)
                }

                topConstraint.constant = min(0.0, -(frameInWindow.maxY - keyboardFrame.minY))

                if let coordinator = sself.transitionCoordinator {
                    coordinator.animate(alongsideTransition: { _ in
                        UIView.performWithoutAnimation {
                            sself.layoutIfNeeded()
                        }
                    }, completion: nil)
                }
                else {
                    sself.layoutIfNeeded()
                }
            }
        }

        return guide
    }

    /**
     Remove the keyboard layout guide. NOTE: you do not need to invoke this method, it is purely optional.
     */
    @nonobjc func removeKeyboardLayoutGuide() {
        if let keyboardLayoutGuide = keyboardLayoutGuide {
            Keyboard.removeFrameObserver(keyboardLayoutGuide)
            removeLayoutGuide(keyboardLayoutGuide)
        }
    }

}
