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
    /// - horizontal: Horizontal direction.
    /// - vertical: Vertical direction.
    /// - custom: Provide start and end CGPoint to specify a custom direction.
    public enum Direction {
        case horizontal
        case vertical
        case custom(start: CGPoint, end: CGPoint)

        var start: CGPoint {
            switch self {
            case .horizontal: return CGPoint(x: 0, y: 0.5)
            case .vertical: return CGPoint(x: 0.5, y: 0)
            case .custom(let start, _): return start
            }
        }

        var end: CGPoint {
            switch self {
            case .horizontal: return CGPoint(x: 1, y: 0.5)
            case .vertical: return CGPoint(x: 0.5, y: 1)
            case .custom(_, let end): return end
            }
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    /// The underlying CAGradientLayer
    public var gradientLayer: CAGradientLayer {
        if let layer = self.layer as? CAGradientLayer {
            return layer
        }
        else {
            fatalError("Backing layer must be a CAGradientLayer")
        }
    }

    /// Create a new instance.
    ///
    /// - Parameters:
    ///   - direction: The direction in which the gradient will be rendered.
    ///   - colors: An array of UIColor instances to be included in the gradient.
    ///   - locations: An optional list of gradient stops. If none is provided, the default behavior is to arrange the colors equally along the axis.
    public init(direction: Direction, colors: [UIColor], locations: [Double]? = nil) {
        super.init(frame: .zero)
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.locations = locations as [NSNumber]?
        gradientLayer.startPoint = direction.start
        gradientLayer.endPoint = direction.end
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
