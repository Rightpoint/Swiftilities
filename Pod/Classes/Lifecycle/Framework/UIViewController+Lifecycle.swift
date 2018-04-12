//
//  UIViewController+Lifecycle.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 6/10/16.
//  Copyright© 2016 Raizlabs
//
//  Based on concepts and examples in:
//  http://khanlou.com/2016/02/many-controllers/ and
//  http://irace.me/lifecycle-behaviors

import UIKit

public extension UIViewController {

    /// Add behaviors to be hooked into this view controller’s lifecycle.
    ///
    /// This method requires the view controller’s view to be loaded, so it’s best to call
    /// in `viewDidLoad` to avoid it being loaded prematurely.
    ///
    /// - Parameter behaviors: The behaviors to add
    public func addBehaviors(_ behaviors: [ViewControllerLifecycleBehavior]) {
        let behaviorViewController = LifecycleBehaviorViewController(behaviors: behaviors)

        loadViewIfNeeded()
        addChildViewController(behaviorViewController)
        view.addSubview(behaviorViewController.view)
        behaviorViewController.didMove(toParentViewController: self)
    }

}
