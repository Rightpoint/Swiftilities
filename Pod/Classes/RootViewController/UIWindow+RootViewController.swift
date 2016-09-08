//
//  UIWindow+RootViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//

import UIKit

/**
 *  UIWindow extension for setting the rootViewController on a UIWindow instance in a safe and animatable way.
 */
public extension UIWindow {

    #if swift(>=3.0)
    /**
     Set the rootViewController on this UIWindow instance.
     
     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     - parameter completion:     Completion block to be invoked after the transition finishes
     */
    func setRootViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void = {}) {
        if animated {

            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)

                self.rootViewController = viewController

                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished) -> Void in
                completion()
            })
        } else {
            self.rootViewController = viewController
        }
    }
    #else
    /**
     Set the rootViewController on this UIWindow instance.

     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     - parameter completion:     Completion block to be invoked after the transition finishes
     */
    func setRootViewController(viewController: UIViewController, animated: Bool, completion: () -> Void = {}) {
        if animated {

            UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
                let oldState = UIView.areAnimationsEnabled()
                UIView.setAnimationsEnabled(false)

                self.rootViewController = viewController

                UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished) -> Void in
                    completion()
            })
        } else {
            self.rootViewController = viewController
        }
    }
    #endif
}
