//
//  DefaultBehaviors.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright© 2016 Raizlabs
//

import Foundation
import ObjectiveC.runtime
import UIKit

public struct DefaultBehaviors {

    private static let forcedIgnoredClasses: [UIViewController.Type] = [
        LifecycleBehaviorViewController.self,
        UINavigationController.self,
        UITabBarController.self,
        ]
    public let behaviors: [ViewControllerLifecycleBehavior]
    public let ignoredClasses: [UIViewController.Type]

    public init(behaviors: [ViewControllerLifecycleBehavior], ignoredClasses: [UIViewController.Type] = []) {
        self.behaviors = behaviors
        self.ignoredClasses = ignoredClasses
    }

    /// **Swizzles** `viewDidLoad` to add default behaviors to all view controllers.
    ///
    /// - Parameter behaviors: The default behaviors to add
    public func inject() {
        let selector = #selector(UIViewController.viewDidLoad)
        typealias ViewDidLoadIMP = @convention(c)(UIViewController, Selector) -> Void

        let instanceViewDidLoad = class_getInstanceMethod(UIViewController.self, selector)
        assert(instanceViewDidLoad != nil, "UIViewController should implement \(selector)")

        var originalIMP: IMP? = nil
        let ignored = self.ignoredClasses
        let behaviors = self.behaviors
        let swizzledIMPBlock: @convention(block) (UIViewController) -> Void = { (receiver) in
            // Invoke the original IMP if it exists
            if originalIMP != nil {
                let imp = unsafeBitCast(originalIMP, to: ViewDidLoadIMP.self)
                imp(receiver, selector)
            }
            DefaultBehaviors.inject(behaviors: behaviors, into: receiver, ignoring: ignored)
        }

        let swizzledIMP = imp_implementationWithBlock(unsafeBitCast(swizzledIMPBlock, to: AnyObject.self))
        originalIMP = method_setImplementation(instanceViewDidLoad!, swizzledIMP)

    }

    private static func inject(behaviors: [ViewControllerLifecycleBehavior],
                               into viewController: UIViewController,
                               ignoring ignoredClasses: [UIViewController.Type]) {
        for type in ignoredClasses + forcedIgnoredClasses {
            guard !viewController.isKind(of: type) else {
                return
            }
        }
        // Prevents swizzing view controllers that are not subclassed from UIKit
        let uiKitBundle = Bundle(for: UIViewController.self)
        let receiverBundle = Bundle(for: type(of: viewController))
        guard uiKitBundle != receiverBundle else {
            return
        }
        viewController.addBehaviors(behaviors)
    }

}
