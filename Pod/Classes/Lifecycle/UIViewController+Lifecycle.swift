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
import ObjectiveC.runtime

public extension UIViewController {

    /// Add behaviors to be hooked into this view controller’s lifecycle.
    ///
    /// This method requires the view controller’s view to be loaded, so it’s best to call
    /// in `viewDidLoad` to avoid it being loaded prematurely.
    ///
    /// - Parameter behaviors: The behaviors to add
    public func addBehaviors(_ behaviors: [ViewControllerLifecycleBehavior]) {
        let behaviorViewController = LifecycleBehaviorViewController(behaviors: behaviors)

        addChildViewController(behaviorViewController)
        view.addSubview(behaviorViewController.view)
        behaviorViewController.didMove(toParentViewController: self)
    }

    /// **Swizzles** `viewDidLoad` to add default behaviors to all view controllers.
    ///
    /// - Parameter behaviors: The default behaviors to add
    public static func setDefaultBehaviors(_ behaviors: [ViewControllerLifecycleBehavior]) {
        let selector = #selector(UIViewController.viewDidLoad)
        typealias ViewDidLoadIMP = @convention(c)(UIViewController, Selector) -> Void

        let instanceViewDidLoad = class_getInstanceMethod(UIViewController.self, selector)
        assert(instanceViewDidLoad != nil, "UIViewController should implement \(selector)")

        var originalIMP: IMP? = nil
        let swizzledIMPBlock: @convention(block) (UIViewController) -> Void = { (receiver) in
            // Invoke the original IMP if it exists
            if originalIMP != nil {
                let imp = unsafeBitCast(originalIMP, to: ViewDidLoadIMP.self)
                imp(receiver, selector)
            }
            injectBehaviors(behaviors, using: receiver)
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledIMPBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(instanceViewDidLoad, swizzledIMP)

    }

    public struct SkippedViewControllers {
        public static var classes: [UIViewController.Type] = []
        private static let forcedClasses: [UIViewController.Type] = [
            LifecycleBehaviorViewController.self,
            UINavigationController.self,
            UITabBarController.self,
            ]

        fileprivate static var allClasses: [UIViewController.Type] {
            return classes + forcedClasses
        }
    }

    private static func injectBehaviors(_ behaviors: [ViewControllerLifecycleBehavior], using viewController: UIViewController) {
        for type in SkippedViewControllers.allClasses {
            guard !viewController.isKind(of: type) else {
                return
            }
        }
        viewController.addBehaviors(behaviors)
    }

}
