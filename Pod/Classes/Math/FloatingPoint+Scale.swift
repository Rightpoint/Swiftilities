//
//  FloatingPoint+Scale.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

public extension FloatingPoint {

    /// Re-maps a number from one range to another.
    ///
    /// - Parameters:
    ///   - source: The range to interpret the number as being a part of.
    ///   - destination: The range to map the number to.
    ///   - timingTransform: An optional transform mapping input percentage to output percentage. Defaults to `nil`
    ///   - clamped: Whether the result should be clamped to the `to` range. Defaults to `false`.
    ///   - reversed: whether the output mapping should be revserd, such that
    ///               as the input increases, the output decreases. Defaults to `false`.
    /// - Returns: The input number, scaled from the `from` range to the `to` range.
    public func scaled(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, clamped: Bool = false, reversed: Bool = false, transform: ((Self) -> Self)? = nil) -> Self {

        let destinationStart = reversed ? destination.upperBound : destination.lowerBound
        let destinationEnd = reversed ? destination.lowerBound : destination.upperBound

        // these are broken up to speed up compile time
        let selfMinusLower = self - source.lowerBound
        let sourceUpperMinusLower = source.upperBound - source.lowerBound
        let destinationUpperMinusLower = destinationEnd - destinationStart

        let percentThroughSource = (selfMinusLower / sourceUpperMinusLower)
        let curvedPercent = transform?(percentThroughSource) ?? percentThroughSource
        var result = curvedPercent * destinationUpperMinusLower + destinationStart

        if clamped {
            result = result.clamped(to: destination)
        }

        return result
    }

}

@available(iOS 10.0, *)
public extension BinaryFloatingPoint {

    public func transformed(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, animationCurve: UIViewAnimationCurve = .linear, clamped: Bool = false, reversed: Bool = false) -> Self {
        let cubic = UICubicTimingParameters(animationCurve: animationCurve)
        return self.transformed(from: source, to: destination, timingCurve: cubic, clamped: clamped, reversed: reversed)
    }

    public func transformed(from source: ClosedRange<Self>, to destination: ClosedRange<Self>, timingCurve: UICubicTimingParameters = UICubicTimingParameters(animationCurve: .linear), clamped: Bool = false, reversed: Bool = false) -> Self {

        return self.scaled(from: source, to: destination, clamped: clamped, reversed: reversed) { input -> Self in
            guard timingCurve.animationCurve != .linear else { return input }
            return Self(CubicBezier.value(for: CGFloat(input.doubleValue),
                                          controlPoint1: timingCurve.controlPoint1,
                                          controlPoint2: timingCurve.controlPoint2).doubleValue)
        }
    }

    private var doubleValue: Double {
        switch self {
        case let value as Double: return value
        case let value as Float: return Double(value)
        case let value as CGFloat: return Double(value)
        default: fatalError("Unsupported floating point type")
        }
    }

}
