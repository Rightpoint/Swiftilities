//
//  DeviceSize.swift
//  Swiftilities
//
//  Created by Rob Cadwallader on 11/1/16.
//

import Foundation
import UIKit

public enum Axis: Int {
    case x
    case y
}

public enum DeviceSize: Hashable {

    case small
    case medium
    case large
    case plus
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

    public static var current: DeviceSize = DeviceSize(size: UIScreen.main.bounds.size)

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
