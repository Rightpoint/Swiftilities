//
//  GradientView.swift
//  Swiftilities
//
//  Created by Nick Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

/// A basic view that wraps CAGradientLayer
public class GradientView: UIView {

    private struct Constants {
        static let leftToRightStart = CGPoint(x: 0, y: 0.5)
        static let leftToRightEnd = CGPoint(x: 1, y: 0.5)
        static let topToBottomStart = CGPoint(x: 0.5, y: 0)
        static let topToBottomEnd = CGPoint(x: 0.5, y: 1)
    }

    /// The direction of the gradient
    ///
    /// - leftToRight: Horizontal direction.
    /// - topToBottom: Vertical direction.
    /// - custom: Provide start and end CGPoint to specify a custom direction.
    public enum Direction {
        case leftToRight
        case topToBottom
        case custom(start: CGPoint, end: CGPoint)

        init(gradientLayer: CAGradientLayer) {
            switch (gradientLayer.startPoint, gradientLayer.endPoint) {
            case (Constants.leftToRightStart, Constants.leftToRightEnd): self = .leftToRight
            case (Constants.topToBottomStart, Constants.topToBottomEnd): self = .topToBottom
            default: self = .custom(start: gradientLayer.startPoint, end: gradientLayer.endPoint)
            }
        }

        var start: CGPoint {
            switch self {
            case .leftToRight: return Constants.leftToRightStart
            case .topToBottom: return Constants.topToBottomStart
            case .custom(let start, _): return start
            }
        }

        var end: CGPoint {
            switch self {
            case .leftToRight: return Constants.leftToRightEnd
            case .topToBottom: return Constants.topToBottomEnd
            case .custom(_, let end): return end
            }
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    /// The underlying CAGradientLayer. Accessing this property directly can be useful
    /// for situations that aren't covered via this wrapper class, in particular animating
    /// any changes to the gradient.
    public var gradientLayer: CAGradientLayer {
        guard let layer = self.layer as? CAGradientLayer else {
            fatalError("Backing layer must be a CAGradientLayer")
        }
        return layer
    }

    /// Passthrough to the underlying `CAGradientLayer` `colors`.
    var colors: [UIColor] {
        get {
            guard let colors = gradientLayer.colors as? [CGColor] else {
                return []
            }
            return colors.map({ UIColor(cgColor: $0) })
        }
        set {
            gradientLayer.colors = newValue.map({ $0.cgColor })
        }
    }

    /// Passthrough to the underlying `CAGradientLayer` `locations`.
    var locations: [Double]? {
        get {
            return gradientLayer.locations as? [Double]
        }
        set {
            gradientLayer.locations = newValue as [NSNumber]?
        }
    }

    /// Passthrough to underlying `CAGradientLayer` `startPoint` and `endPoint`.
    var direction: Direction {
        get {
            return Direction(gradientLayer: gradientLayer)
        }
        set {
            gradientLayer.startPoint = newValue.start
            gradientLayer.endPoint = newValue.end
        }
    }

    /// Create a new instance.
    ///
    /// - Parameters:
    ///   - direction: The direction in which the gradient will be rendered.
    ///   - colors: An array of colors to be included in the gradient.
    ///   - locations: An optional list of gradient stops. If none are provided, the default behavior is to arrange the colors evenly.
    public init(direction: Direction, colors: [UIColor], locations: [Double]? = nil) {
        super.init(frame: .zero)
        self.direction = direction
        self.colors = colors
        self.locations = locations
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.direction = .leftToRight
        self.colors = [.white, .black]
    }

}
