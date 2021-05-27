//
//  AppDelegate.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 02/05/2016.
//  Copyright (c) 2016 Nicholas Bonatsakis. All rights reserved.
//

import Swiftilities
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Log.trace("DefaultBehaviors", type: .begin)
        DefaultBehaviors(behaviors: [LogAppearanceBehavior()]).inject()
        Log.trace("DefaultBehaviors", type: .end)
        return true
    }
}
