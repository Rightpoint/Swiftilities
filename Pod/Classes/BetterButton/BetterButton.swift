//
//  BetterButton.swift
//  Swiftilities
//
//  Created by Nick Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

private struct StyleConstants {

    /// The threshold used to decide if highlight state should darken or lighten.
    static let highlightLightenDarkenThreshold: CGFloat = 0.10
    /// The darken highlight percentage. ranges
    static let defaultHighlightDarkenAdjustStart: CGFloat = 0.10
    static let defaultHighlightDarkenAdjustEnd: CGFloat = 0.40
    /// The lighten highlight percentage.
    static let defaultHighlightLightenAdjust: CGFloat = 0.25

}

/// A "better" version of `UIButton` that supports various button styles and shapes.
open class BetterButton: UIButton {

    /// The shape of the button.
    ///
    /// - rectangle: A rectangle with specified corner radius.
    /// - circle: A circle with radius based on the bounds of the button.
    /// - pill: A pill with end caps based on the bounds of the button.
    public enum Shape {

        case rectangle(cornerRadius: CGFloat)
        case circle
        case pill

    }

    /// The style of the button. Impacts visual look and highlight behavior.
    ///
    /// - solid: A solid color button. Highlight state darkens or lightens background and content.
    /// - outlineOnly: A stroke-outlined button. Highlight lightens or darkens outline and content.
    /// - outlineInvert: Similar to `outlineOnly`, but onhighlight, inverts background and foreground (like App Store "GET" button).
    /// - custom: Entirely customized by passing an instance of `StyleAttributes`
    public enum Style {

        case solid(backgroundColor: UIColor, foregroundColor: UIColor)
        case outlineOnly(backgroundColor: UIColor, foregroundColor: UIColor)
        case outlineInvert(backgroundColor: UIColor, foregroundColor: UIColor)
        case custom(StyleAttributes)

    }

    /// Attributes used to style the button.
    public struct StyleAttributes {

        /// Defines the highlight behavior for a button.
        ///
        /// - darken: Darken by a percentage.
        /// - lighten: Lighten by a percentage.
        public enum HighlightAdjustMode {
            case darken(by: CGFloat?)
            case lighten(by: CGFloat?)

            func adjustedColor(from color: UIColor) -> UIColor {
                switch self {
                case .darken(let adjustmentOverride):
                    let adjustment = adjustmentOverride ?? StyleConstants.defaultHighlightDarkenAdjustStart
                    return color.darkened(by: adjustment)
                case .lighten(let adjustmentOverride):
                    let adjustment = adjustmentOverride ?? StyleConstants.defaultHighlightLightenAdjust
                    return color.lightened(by: adjustment)
                }
            }

            /// Produces a darken enum value based on the provided brightness. The lighter the color, the darker the adjustment.
            ///
            /// - Parameter brightness: The brightness value
            /// - Returns: A draken adjust mode enum value
            static func darkenAdjust(forBrightness brightness: CGFloat) -> HighlightAdjustMode {
                let adjust = brightness.scaled(
                    from: StyleConstants.highlightLightenDarkenThreshold...1.0,
                    to: StyleConstants.defaultHighlightDarkenAdjustStart...StyleConstants.defaultHighlightDarkenAdjustEnd)
                return .darken(by: adjust)
            }

        }

        var backgroundColor: UIColor
        var highlightedBackgroundColor: UIColor
        var foregroundColor: UIColor
        var highlightedForegroundColor: UIColor
        var borderColor: UIColor?
        var highlightedBorderColor: UIColor?
        var borderWidth: CGFloat?
        var adjustMode: HighlightAdjustMode

        public init(
            backgroundColor: UIColor,
            highlightedBackgroundColor: UIColor?,
            foregroundColor: UIColor,
            highlightedForegroundColor: UIColor?,
            borderColor: UIColor?,
            highlightedBorderColor: UIColor?,
            borderWidth: CGFloat?,
            adjustMode: HighlightAdjustMode = .darken(by: nil)
            ) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.adjustMode = adjustMode

            // Highlighted Background

            if let highlightedBackgroundColor = highlightedBackgroundColor {
                self.highlightedBackgroundColor = highlightedBackgroundColor
            }
            else {
                self.highlightedBackgroundColor = adjustMode.adjustedColor(from: backgroundColor)
            }

            // Highlighted Foreground

            if let highlightedForegroundColor = highlightedForegroundColor {
                self.highlightedForegroundColor = highlightedForegroundColor
            }
            else {
                self.highlightedForegroundColor = adjustMode.adjustedColor(from: foregroundColor)
            }

            // Border

            self.borderColor = borderColor
            self.borderWidth = borderWidth

            if let borderColor = borderColor {
                if let highlightedBorderColor = highlightedBorderColor {
                    self.highlightedBorderColor = highlightedBorderColor
                }
                else {
                    self.highlightedBorderColor = adjustMode.adjustedColor(from: borderColor)
                }
            }
        }

    }

    // Properties

    /// The button shape.
    public let shape: Shape

    /// The button style.
    public let style: Style

    /// Use this property to set an image rather than using `setImage:forState`.
    /// The image will be re-rendered and the button configured appropriately to
    /// satisfy the provided style.
    public var iconImage: UIImage? {
        didSet {
            if let image = iconImage {
                let styleAttributes = style.attributes
                let normalImage = image.tintedImage(color: styleAttributes.foregroundColor)
                let highlightedImage = image.tintedImage(color: styleAttributes.highlightedForegroundColor)
                self.setImage(normalImage, for: .normal)
                self.setImage(highlightedImage, for: .highlighted)
                self.setImage(highlightedImage, for: .selected)
            }
        }
    }

    /// Setting this property to `true` will replace the button content with an
    /// activity indicator and disable user interaction. Set to `false` to restore initial button state/behavior.
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }

            self.isUserInteractionEnabled = !isLoading
            self.imageView?.isHidden = isLoading
            self.titleLabel?.isHidden = isLoading
        }
    }

    // TODO: Investigate allowing content to remain, with offset spinner.
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.hidesWhenStopped = true
        return view
    }()

    /// Create a new instance.
    ///
    /// - Parameters:
    ///   - shape: The desired button shape.
    ///   - style: The desired button style.
    public init(shape: Shape, style: Style) {
        self.shape = shape
        self.style = style
        super.init(frame: .zero)

        addSubview(activityIndicator)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("BetterButton does not yet support the use of Interface Builder.")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        self.bringSubview(toFront: activityIndicator)
        self.imageView?.isHidden = isLoading
        self.titleLabel?.isHidden = isLoading
    }

    override open var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            render()
        }
    }

    override open var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            render()
        }
    }
}

// MARK: Rendering

private extension BetterButton {

    func render() {
        let styleAttributes = style.attributes

        setTitleColor(styleAttributes.foregroundColor, for: .normal)
        setTitleColor(styleAttributes.highlightedForegroundColor, for: .highlighted)
        setTitleColor(styleAttributes.highlightedForegroundColor, for: .selected)

        let backgroundImage = Shapes.image(for: shape.shapesShape,
                                           size: bounds.size,
                                           attributes: styleAttributes.shapeAttributes(forHighlighted: false)
        )
        self.setBackgroundImage(backgroundImage, for: .normal)

        let highlightedBackgroundImage = Shapes.image(for: shape.shapesShape,
                                           size: bounds.size,
                                           attributes: styleAttributes.shapeAttributes(forHighlighted: true)
        )
        self.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        self.setBackgroundImage(highlightedBackgroundImage, for: .selected)

        activityIndicator.color = styleAttributes.foregroundColor
    }
}

// MARK: Styling

private extension BetterButton.Style {

    var attributes: BetterButton.StyleAttributes {
        switch self {
        case .solid(let backgroundColor, let foregroundColor):
            let adjustMode = highlightAdjustMode(forBrightness: backgroundColor.averageBrightness)
            return BetterButton.StyleAttributes(
                backgroundColor: backgroundColor,
                highlightedBackgroundColor: nil,
                foregroundColor: foregroundColor,
                highlightedForegroundColor: nil,
                borderColor: nil,
                highlightedBorderColor: nil,
                borderWidth: nil,
                adjustMode: adjustMode)
        case .outlineOnly(let backgroundColor, let foregroundColor):
            let adjustMode = highlightAdjustMode(forBrightness: foregroundColor.averageBrightness)
            return BetterButton.StyleAttributes(
                backgroundColor: backgroundColor,
                highlightedBackgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                highlightedForegroundColor: nil,
                borderColor: foregroundColor,
                highlightedBorderColor: nil,
                borderWidth: 1.0,
            adjustMode: adjustMode)
        case .outlineInvert(let backgroundColor, let foregroundColor):
            return BetterButton.StyleAttributes(
                backgroundColor: backgroundColor,
                highlightedBackgroundColor: foregroundColor,
                foregroundColor: foregroundColor,
                highlightedForegroundColor: backgroundColor,
                borderColor: foregroundColor,
                highlightedBorderColor: foregroundColor,
                borderWidth: 1.0)
        case .custom(let attributes):
            return attributes
        }
    }

    func highlightAdjustMode(forBrightness brightness: CGFloat) -> BetterButton.StyleAttributes.HighlightAdjustMode {
        if brightness > StyleConstants.highlightLightenDarkenThreshold {
            return BetterButton.StyleAttributes.HighlightAdjustMode.darkenAdjust(forBrightness: brightness)
        }
        else {
            return .lighten(by: nil)
        }
    }

}

// MARK: Shape Translation

extension BetterButton.Shape {

    var shapesShape: Shapes.Shape {
        switch self {
        case .rectangle(let cornerRadius): return Shapes.Shape.rectangle(cornerRadius: cornerRadius)
        case .circle: return Shapes.Shape.circle
        case .pill: return Shapes.Shape.pill
        }
    }

}

extension BetterButton.StyleAttributes {

    func shapeAttributes(forHighlighted highlighted: Bool) -> [Shapes.Attribute] {
        var attributes: [Shapes.Attribute] = []

        if highlighted {
            attributes.append(.fillColor(self.highlightedBackgroundColor))
            if let borderColor = self.highlightedBorderColor {
                attributes.append(.strokeColor(borderColor))
            }
        }
        else {
            attributes.append(.fillColor(self.backgroundColor))
            if let borderColor = self.borderColor {
                attributes.append(.strokeColor(borderColor))
            }
        }

        if let borderWidth = self.borderWidth {
            attributes.append(.lineWidth(borderWidth))
        }

        return attributes
    }

}
