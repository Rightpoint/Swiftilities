//
//  LogAppearanceBehavior.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/23/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit
import Swiftilities

struct LogAppearanceBehavior: ViewControllerLifecycleBehavior {

    public func beforeAppearing(_ viewController: UIViewController, animated: Bool) {
        // Logger

        Log.logLevel = .info
        Log.info("\(type(of: viewController))")
    }

}
