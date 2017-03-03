//
//  AppInfo.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/28/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation

enum AppInfo {

    private static var unknownKeyString: String {
        return NSLocalizedString("Unknown", comment: "Indicates that a field in the app info is unknown")
    }

    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    static var name: String {
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return bundleName ?? unknownKeyString
    }

    static var version: String {
        let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return bundleVersion ?? unknownKeyString
    }

    static var accessibleVersion: String {
        if UIAccessibilityIsVoiceOverRunning() {
            let separator = NSLocalizedString(" point ", comment: "The spelled out version of the “point” in version numbers, like 2 point 0 point 1, with spaces on either side")
            return version.components(separatedBy: ".").joined(separator: separator)
        }
        else {
            return version
        }
    }

    static var buildNumber: String {
        let bundleVersionKey = kCFBundleVersionKey as String
        let bundleBuild = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        return bundleBuild ?? unknownKeyString
    }

    static var infoText: String {
        return ["App Version \(version)", "iOS Version: \(systemVersion)"].joined(separator: "\n")
    }

    static var deviceModel: String {
        // adapted from http://stackoverflow.com/questions/26028918/ios-how-to-determine-the-current-iphone-device-model-in-swift
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)

        var identifier = ""
        for element in mirror.children {
            if let value = element.value as? Int8, value != 0 {
                identifier += String(UnicodeScalar(UInt8(value)))
            }
        }
        return identifier
    }

}
