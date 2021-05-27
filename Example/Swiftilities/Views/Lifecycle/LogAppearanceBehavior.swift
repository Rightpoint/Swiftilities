//
//  LogAppearanceBehavior.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import UIKit

struct LogAppearanceBehavior: ViewControllerLifecycleBehavior {

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {
        // Logger

        Log.trace("beforeAppearing", type: .event)
        Log.logLevel = .info
        Log.info("\(type(of: viewController))")
    }

}
