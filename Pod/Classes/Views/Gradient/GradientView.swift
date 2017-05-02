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

    /// The direction of the gradient
    ///
    /// - leftToRight: Horizontal direction.
    /// - topToBottom: Vertical direction.
    /// - custom: Provide start and end CGPoint to specify a custom direction.
    public enum Direction {
        case leftToRight
        case topToBottom
        case custom(start: CGPoint, end: CGPoint)

        var start: CGPoint {
            switch self {
            case .leftToRight: return CGPoint(x: 0, y: 0.5)
            case .topToBottom: return CGPoint(x: 0.5, y: 0)
            case .custom(let start, _): return start
            }
        }

        var end: CGPoint {
            switch self {
            case .leftToRight: return CGPoint(x: 1, y: 0.5)
            case .topToBottom: return CGPoint(x: 0.5, y: 1)
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

    /// Create a new instance.
    ///
    /// - Parameters:
    ///   - direction: The direction in which the gradient will be rendered.
    ///   - colors: An array of colors to be included in the gradient.
    ///   - locations: An optional list of gradient stops. If none are provided, the default behavior is to arrange the colors evenly.
    public init(direction: Direction, colors: [UIColor], locations: [Double]? = nil) {
        super.init(frame: .zero)
        set(direction: direction)
        set(colors: colors)
        if let locations = locations {
            set(locations: locations)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        set(direction: .leftToRight)
        set(colors: [.white, .black])
    }

    /// Updates the direction for the backing gradient layer.
    ///
    /// - Parameter direction: The new direction.
    public func set(direction: Direction) {
        gradientLayer.startPoint = direction.start
        gradientLayer.endPoint = direction.end
    }

    /// Updates the colors for the backing gradient layer.
    ///
    /// - Parameter colors: The new colors.
    public func set(colors: [UIColor]) {
        gradientLayer.colors = colors.map({$0.cgColor})
    }

    /// Updates the locations for the backing gradient layer.
    ///
    /// - Parameter locations: The new colors.
    public func set(locations: [Double]) {
        gradientLayer.locations = locations as [NSNumber]?
    }

}
