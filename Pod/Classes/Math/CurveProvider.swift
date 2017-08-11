//
//  CurveProvider.swift
//  Pods
//
//  Created by Jason Clark on 8/10/17.
//
//

import Foundation

public protocol CurveProvider {

    func map<T: BinaryFloatingPoint>(_ inputPercent: T) -> T

}

@available(iOS 10.0, *)
extension UICubicTimingParameters: CurveProvider {

    public func map<T: BinaryFloatingPoint>(_ inputPercent: T) -> T {
        guard animationCurve != .linear else { return inputPercent }
        return T(CubicBezier.value(for: CGFloat(inputPercent.doubleValue),
                                   controlPoint1: controlPoint1,
                                   controlPoint2: controlPoint2).doubleValue)
    }

}

extension UIViewAnimationCurve: CurveProvider {

    public func map<T: BinaryFloatingPoint>(_ inputPercent: T) -> T {
        guard self != .linear else { return inputPercent }
        if #available(iOS 10.0, *) {
            return UICubicTimingParameters(animationCurve: self).map(inputPercent)
        }
        else {
            let controlPoint1, controlPoint2: CGPoint
            switch self {
            case .linear:
                controlPoint1 = CGPoint(x: 0, y: 0)
                controlPoint2 = CGPoint(x: 1, y: 1)
            case .easeIn:
                controlPoint1 = CGPoint(x: 0.42, y: 0)
                controlPoint2 = CGPoint(x: 1, y: 1)
            case .easeOut:
                controlPoint1 = CGPoint(x: 0, y: 0)
                controlPoint2 = CGPoint(x: 0.58, y: 1)
            case .easeInOut:
                controlPoint1 = CGPoint(x: 0.42, y: 0)
                controlPoint2 = CGPoint(x: 0.58, y: 1)
            }
            return T(CubicBezier.value(for: CGFloat(inputPercent.doubleValue),
                                       controlPoint1: controlPoint1,
                                       controlPoint2: controlPoint2).doubleValue)

        }
    }

}

extension BinaryFloatingPoint {

    var doubleValue: Double {
        switch self {
        case let value as Double: return value
        case let value as Float: return Double(value)
        case let value as CGFloat: return Double(value)
        default: fatalError("Unsupported floating point type")
        }
    }

}
