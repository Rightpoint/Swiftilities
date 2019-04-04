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
    /// - outlineInvert: Similar to `outlineOnly`, but onhighlight, inverts background and foreground.
    /// - custom: Entirely customized
    public enum Style {

        /// A solid color button. Highlight state darkens or lightens background and content.
        case solid(backgroundColor: UIColor, foregroundColor: UIColor)
        
        /// A stroke-outlined button. Highlight lightens or darkens outline and content.
        case outlineOnly(backgroundColor: UIColor, foregroundColor: UIColor)
        
        /// Similar to `outlineOnly`, but onhighlight, inverts background and foreground.
        case outlineInvert(backgroundColor: UIColor, foregroundColor: UIColor)
        /**
         Defines a custom BetterButton configuration
        
         - Params:
             - normal: Required *StyleAttributes* for *UIControl.State.normal*.
             - customStateStyles: Attributes to apply based on a designated `UIControl.State`. Last given style per `UIControl.State` takes precedence. Will overwrite `normal` and `adjustMode`
             - adjustMode: Optional adjustment to apply to the <normal> style for `UIControl.State.selected` and `UIControl.State.highlighted`. Subordinate to `customStateStyles`
         */
        case custom(normal: StyleAttributes, customStateStyles: [StateStyle], adjustMode: HighlightAdjustMode?)
        
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
            
            func adjustedStyleAttributes(from baseline: StyleAttributes) -> StyleAttributes {
                return StyleAttributes(
                    backgroundColor: adjustedColor(from: baseline.backgroundColor),
                    foregroundColor: adjustedColor(from: baseline.foregroundColor),
                    borderColor: adjustedColor(from: baseline.foregroundColor),
                    borderWidth: baseline.borderWidth)
            }

            /// Produces a darken enum value based on the provided brightness. The lighter the color, the darker the adjustment.
            ///
            /// - Parameter brightness: The brightness value
            /// - Returns: A darken adjust mode enum value
            static func darkenAdjust(forBrightness brightness: CGFloat) -> HighlightAdjustMode {
                let adjust = brightness.scaled(
                    from: StyleConstants.highlightLightenDarkenThreshold...1.0,
                    to: StyleConstants.defaultHighlightDarkenAdjustStart...StyleConstants.defaultHighlightDarkenAdjustEnd)
                return .darken(by: adjust)
            }

        }
        
    }
    
    /// A UIControl.State context wrapper for `BetterButton.StyleAttributes`
    public struct StateStyle {
        public let controlState: UIControl.State
        public let styleAttributes: StyleAttributes
        
        public init(controlState: UIControl.State, attributes: StyleAttributes) {
            self.controlState = controlState
            self.styleAttributes = attributes
        }
    }

    /// Attributes used to style the `BetterButton`
    public struct StyleAttributes {

        public var backgroundColor: UIColor
        public var foregroundColor: UIColor
        public var borderColor: UIColor?
        public var borderWidth: CGFloat?

        public init(
            backgroundColor: UIColor,
            foregroundColor: UIColor,
            borderColor: UIColor?,
            borderWidth: CGFloat?
            ) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
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
                configureImage(image, for: style)
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
        let view = UIActivityIndicatorView(style: .white)
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
        self.bringSubviewToFront(activityIndicator)
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
        configureTitle(for: style)
        configureBackground(for: style)
        activityIndicator.color = style.activityIndicatorColor
    }
    
    func configureTitle(for style: Style) {
        style.stateStyles.forEach { stateStyle in
            setTitleColor(stateStyle.styleAttributes.foregroundColor, for: stateStyle.controlState)
        }
    }
    
    func configureBackground(for style: Style) {
        style.stateStyles.forEach { stateStyle in
            let backgroundImage = Shapes.image(for: shape.shapesShape, size: bounds.size, attributes: stateStyle.styleAttributes.shapeAttributes)
            setBackgroundImage(backgroundImage, for: stateStyle.controlState)
        }
    }
    
    func configureImage(_ image: UIImage, for style: Style) {
        style.stateStyles.forEach { stateStyle in
            let styledImage = image.tintedImage(color: stateStyle.styleAttributes.foregroundColor)
            setImage(styledImage, for: stateStyle.controlState)
        }
    }
}

// MARK: Styling

private extension BetterButton.Style {
    
    var activityIndicatorColor: UIColor {
        return stateStyles.first(where: { $0.controlState == .normal })?.styleAttributes.foregroundColor ?? .white
    }
    
    var stateStyles: [BetterButton.StateStyle] {
        switch self {
        case .solid(let backgroundColor, let foregroundColor):
            let adjustMode = highlightAdjustMode(forBrightness: backgroundColor.averageBrightness)
            let baselineAttributes = BetterButton.StyleAttributes(backgroundColor: backgroundColor, foregroundColor: foregroundColor, borderColor: nil, borderWidth: nil)
            let adjustedAttributes = adjustMode.adjustedStyleAttributes(from: baselineAttributes)
            return [
                BetterButton.StateStyle(controlState: .normal, attributes: baselineAttributes),
                BetterButton.StateStyle(controlState: .highlighted, attributes: adjustedAttributes),
                BetterButton.StateStyle(controlState: .selected, attributes: adjustedAttributes),
            ]
        case .outlineOnly(let backgroundColor, let foregroundColor):
            let adjustMode = highlightAdjustMode(forBrightness: foregroundColor.averageBrightness)
            let baselineAttributes = BetterButton.StyleAttributes(backgroundColor: backgroundColor, foregroundColor: foregroundColor, borderColor: foregroundColor, borderWidth: 1.0)
            let adjustedAttributtes = adjustMode.adjustedStyleAttributes(from: baselineAttributes)
            return [
                BetterButton.StateStyle(controlState: .normal, attributes: baselineAttributes),
                BetterButton.StateStyle(controlState: .highlighted, attributes: adjustedAttributtes),
                BetterButton.StateStyle(controlState: .selected, attributes: adjustedAttributtes),
            ]
        case .outlineInvert(let backgroundColor, let foregroundColor):
            let baselineAttributes = BetterButton.StyleAttributes(backgroundColor: backgroundColor, foregroundColor: foregroundColor, borderColor: foregroundColor, borderWidth: 1.0)
            let invertedAttributtes = BetterButton.StyleAttributes(backgroundColor: foregroundColor, foregroundColor: backgroundColor, borderColor: foregroundColor, borderWidth: 1.0)
            return [
                BetterButton.StateStyle(controlState: .normal, attributes: baselineAttributes),
                BetterButton.StateStyle(controlState: .highlighted, attributes: invertedAttributtes),
                BetterButton.StateStyle(controlState: .selected, attributes: invertedAttributtes),
            ]
        case .custom(normal: let baselineAttributes, customStateStyles: let customStyles, adjustMode: let adjustMode):
            // Start with the `.normal` state style.
            var stateStyles: [BetterButton.StateStyle] = [BetterButton.StateStyle(controlState: .normal, attributes: baselineAttributes)]
            
            // Second, if an adjustMode is provided, add default highlighted and selected states.
            if let adjustment = adjustMode {
                let adjustedAttributes = adjustment.adjustedStyleAttributes(from: baselineAttributes)
                stateStyles += [
                    BetterButton.StateStyle(controlState: .highlighted, attributes: adjustedAttributes),
                    BetterButton.StateStyle(controlState: .selected, attributes: adjustedAttributes),
                ]
            }
            
            // Last, add the custom styles
            stateStyles += customStyles
            
            return stateStyles
        }
    }

    func highlightAdjustMode(forBrightness brightness: CGFloat) -> BetterButton.Style.HighlightAdjustMode {
        if brightness > StyleConstants.highlightLightenDarkenThreshold {
            return BetterButton.Style.HighlightAdjustMode.darkenAdjust(forBrightness: brightness)
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
    
    var shapeAttributes: [Shapes.Attribute] {
        var attributes: [Shapes.Attribute] = []
        attributes.append(.fillColor(self.backgroundColor))
        if let borderColor = self.borderColor {
            attributes.append(.strokeColor(borderColor))
        }
        if let borderWidth = self.borderWidth {
            attributes.append(.lineWidth(borderWidth))
        }
        
        return attributes
    }
    
}
