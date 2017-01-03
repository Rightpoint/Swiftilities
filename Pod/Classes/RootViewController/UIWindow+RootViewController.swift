//
//  UIWindow+RootViewController.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/**
 *  UIWindow extension for setting the rootViewController on a UIWindow instance in a safe and animatable way.
 */
public extension UIWindow {

    /**
     Set the rootViewController on this UIWindow instance.
     
     - parameter viewController: The view controller to set
     - parameter animated:       Whether or not to animate the transition, animation is a cross-fade
     - parameter completion:     Completion block to be invoked after the transition finishes
     */
    @nonobjc func setRootViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void = {}) {
        if animated {

            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)

                self.rootViewController = viewController

                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ -> Void in
                completion()
            })
        }
        else {
            self.rootViewController = viewController
        }
    }
}
