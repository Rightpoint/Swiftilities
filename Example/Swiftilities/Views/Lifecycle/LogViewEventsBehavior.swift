//
//  LogViewEventsBehavior.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation
import Swiftilities

struct LogViewEventsBehavior: ViewControllerLifecycleBehavior {

    private func logEvent(_ description: String, in viewController: UIViewController) {
        if let logger = (viewController as? LifecycleDemoViewController)?.lifecycleDelegate {
            logger.logEvent(description: "\(description)")
        }
    }

    public func afterLoading(_ viewController: UIViewController) {
        logEvent("After loading", in: viewController)
    }

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {
        logEvent("Before appearing", in: viewController)
    }

    public func afterAppearing(_ viewController: UIViewController, animated: Bool) {
        logEvent("After appearing", in: viewController)
    }

    public func beforeDisappearing(_ viewController: UIViewController, animated: Bool) {
        logEvent("Before disappearing", in: viewController)
    }

    public func afterDisappearing(_ viewController: UIViewController, animated: Bool) {
        logEvent("After disappearing", in: viewController)
    }

    public func beforeLayingOutSubviews(_ viewController: UIViewController) {
        logEvent("Before laying out subviews", in: viewController)
    }

    public func afterLayingOutSubviews(_ viewController: UIViewController) {
        logEvent("After laying out subviews", in: viewController)
    }

}
