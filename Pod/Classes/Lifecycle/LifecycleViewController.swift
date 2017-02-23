//
//  LifecycleViewController.swift
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

    struct Static {
        static var enableToken: Int = 0
    }

    private static var hasEnabledLifecycleBehavior: Bool = false

    public class func enableLifecyleBehavior() {
        if !hasEnabledLifecycleBehavior {
            hasEnabledLifecycleBehavior = true
            EnableAppearanceViewControllerLifecycleBehavior()
            EnableStatusViewControllerLifecycleBehavior()
        }
    }

    fileprivate class BehaviorContainer: NSObject {
        fileprivate static var Handle: UInt8 = 0

        var behaviors: [ViewControllerLifecycleBehavior] = []
        init(behaviors: [ViewControllerLifecycleBehavior]) {
            self.behaviors = behaviors
        }
    }

    public static var globalBehaviors: [ViewControllerLifecycleBehavior] = []

    public var behaviors: [ViewControllerLifecycleBehavior] {
        set {
            objc_setAssociatedObject(self, &BehaviorContainer.Handle, BehaviorContainer(behaviors: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            guard let behaviorContainer = objc_getAssociatedObject(self, &BehaviorContainer.Handle) as? BehaviorContainer else {
                return []
            }
            return behaviorContainer.behaviors
        }
    }

    var allBehaviors: [ViewControllerLifecycleBehavior] {
        var behaviors = self.behaviors
        let dynamicGlobalBehaviors = type(of: self).globalBehaviors
        behaviors.append(contentsOf: dynamicGlobalBehaviors)
        return behaviors
    }

}

private func EnableAppearanceViewControllerLifecycleBehavior() {

    typealias AppearanceIMP = @convention(c)(UIViewController, Selector, Bool) -> Void
    let appearanceSelectors = [
        #selector(UIViewController.viewWillAppear(_:)),
        #selector(UIViewController.viewDidAppear(_:)),
        #selector(UIViewController.viewWillDisappear(_:)),
        #selector(UIViewController.viewDidDisappear(_:)),
        ]
    for selector in appearanceSelectors {

        let appearance = class_getInstanceMethod(UIViewController.self, selector)
        assert(appearance != nil, "UIViewController should implement \(selector)")

        var originalIMP: IMP? = nil
        let swizzledIMPBlock: @convention(block) (UIViewController, Bool) -> Void = { (receiver, animated) in
            TriggerAppearanceBehaviors(receiver, selector: selector, animated: animated)

            // Invoke the original IMP if it exists
            if originalIMP != nil {
                let imp = unsafeBitCast(originalIMP, to: AppearanceIMP.self)
                imp(receiver, selector, animated)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledIMPBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(appearance, swizzledIMP)
    }

}

private func EnableStatusViewControllerLifecycleBehavior() {

    let statusSelectors = [
        #selector(UIViewController.viewDidLoad),
        #selector(UIViewController.viewWillLayoutSubviews), #selector(UIViewController.viewDidLayoutSubviews),
        ]

    for selector in statusSelectors {
        typealias StatusIMP = @convention(c)(UIViewController, Selector) -> Void

        let appearance = class_getInstanceMethod(UIViewController.self, selector)
        assert(appearance != nil, "UIViewController should implement \(selector)")

        var originalIMP: IMP? = nil
        let swizzledIMPBlock: @convention(block) (UIViewController) -> Void = { (receiver) in
            TriggerStatusBehaviors(receiver, selector: selector)
            // Invoke the original IMP if it exists
            if originalIMP != nil {
                let imp = unsafeBitCast(originalIMP, to: StatusIMP.self)
                imp(receiver, selector)
            }
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledIMPBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(appearance, swizzledIMP)
    }

}

private func TriggerAppearanceBehaviors(_ viewController: UIViewController, selector: Selector, animated: Bool) {

    for behavior in viewController.allBehaviors {
        switch selector {
        case #selector(UIViewController.viewWillAppear(_:)):
            behavior.beforeAppearing(viewController, animated: animated)
        case #selector(UIViewController.viewDidAppear(_:)):
            behavior.afterAppearing(viewController, animated: animated)
        case #selector(UIViewController.viewWillDisappear(_:)):
            behavior.beforeDisappearing(viewController, animated: animated)
        case #selector(UIViewController.viewDidDisappear(_:)):
            behavior.afterDisappearing(viewController, animated: animated)
        default:
            fatalError("Unknown selector \(selector)")
        }
    }

}

private func TriggerStatusBehaviors(_ viewController: UIViewController, selector: Selector) {

    for behavior in viewController.allBehaviors {
        switch selector {
        case #selector(UIViewController.viewDidLoad):
            behavior.afterLoading(viewController)
        case #selector(UIViewController.viewWillLayoutSubviews):
            behavior.beforeLayingOutSubviews(viewController)
        case #selector(UIViewController.viewDidLayoutSubviews):
            behavior.afterLayingOutSubviews(viewController)
        default:
            fatalError("Unknown selector \(selector)")
        }
    }
    
}
