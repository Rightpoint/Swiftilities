//
//  DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/1/16.
//
//  Tools for adjusting values given the current screen size.
//

import Foundation
import UIKit

//swiftlint:disable identifier_name
public enum Axis: Int {
    case x
    case y
}
//swiftlint:enable identifier_name

/**
 Represents the screen size of a device
 */
public enum DeviceSize: Hashable {

    case small // e.g. Original iPhone -> iPhone 4s
    case medium // e.g. iPhone 5, iPod Touch 5th and 6th gen
    case large // e.g. iPhone 6, iPhone 7
    case plus // e.g. iPhone 6 Plus, iPhone 7 Plus
    case other(CGSize)

    init(size: CGSize) {
        switch size {
        case DeviceSize.small.dimensions:
            self = .small
        case DeviceSize.medium.dimensions:
            self = .medium
        case DeviceSize.large.dimensions:
            self = .large
        case DeviceSize.plus.dimensions:
            self = .plus
        default:
            self = .other(size)
        }
    }

    /**
     Screen size of the current device as reported by UIScreen
     */
    public static var current: DeviceSize = DeviceSize(size: UIScreen.main.bounds.size)

    /**
     Conditionally return a value given the current device screen size. For example:

     let result = DeviceSize.adjust(25, for: [.small: 50, .large: 100])
     print(result) // Prints 100 when DeviceSize.current == .large

     - parameter default: Value that will be returned if DeviceSize.current is not a key in overrides.
     - parameter overrides: A dictionary specifying the values to return for specific DeviceSizes.
     */
    public static func adjust<ValueType>(_ default: ValueType, for overrides: [DeviceSize: ValueType]) -> ValueType {
        return overrides[DeviceSize.current] ?? `default`
    }
}

public extension DeviceSize {

    var dimensions: CGSize {
        switch self {
        case .small: return CGSize(width: 320, height: 480)
        case .medium: return CGSize(width: 320, height: 568)
        case .large: return CGSize(width: 375, height: 667)
        case .plus: return CGSize(width: 414, height: 736)
        case .other(let size): return size
        }
    }

    var hashValue: Int {
        let a: Int = Int(dimensions.width)
        let b: Int = Int(dimensions.height)

        // Using Cantor's pairing function:
        return (a + b) * (a + b + 1) / 2 + b
    }
}

public func == (lhs: DeviceSize, rhs: DeviceSize) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
