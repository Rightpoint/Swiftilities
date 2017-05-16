//
//  BetterButton.swift
//  Swiftilities
//
//  Created by Nick Bonatsakis on 5/1/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

fileprivate struct StyleConstants {

    static let highlightLightenDarkenThreshold: CGFloat = 0.10
    static let defaultHighlightDarkenAdjust: CGFloat = 0.10
    static let defaultHighlightLightenAdjust: CGFloat = 0.25

}

public class BetterButton: UIButton {

    public enum Shape {

        case rectangle(cornerRadius: CGFloat)
        case circle
        case pill

    }

    public enum Style {

        case solid(backgroundColor: UIColor, foregroundColor: UIColor)
        case outlineOnly(backgroundColor: UIColor, foregroundColor: UIColor)
        case outlineInvert(backgroundColor: UIColor, foregroundColor: UIColor)
        case custom(StyleAttributes)

    }

    public struct StyleAttributes {

        enum HighlightAdjustMode {
            case darken(by: CGFloat?)
            case lighten(by: CGFloat?)

            func adjustedColor(from color: UIColor) -> UIColor {
                switch self {
                case .darken(let adjustmentOverride):
                    let adjustment = adjustmentOverride ?? StyleConstants.defaultHighlightDarkenAdjust
                    return color.darkened(by: adjustment)
                case .lighten(let adjustmentOverride):
                    let adjustment = adjustmentOverride ?? StyleConstants.defaultHighlightLightenAdjust
                    return color.lightened(by: adjustment)
                }
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

        init(backgroundColor: UIColor,
             highlightedBackgroundColor: UIColor?,
             foregroundColor: UIColor,
             highlightedForegroundColor: UIColor?,
             borderColor: UIColor?,
             highlightedBorderColor: UIColor?,
             borderWidth: CGFloat?,
             adjustMode: HighlightAdjustMode = .darken(by: nil)) {

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

    public let shape: Shape

    public let style: Style

    public init(shape: Shape, style: Style) {
        self.shape = shape
        self.style = style
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        render()
    }

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

}

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
    }
}

private extension BetterButton.Style {

    var attributes: BetterButton.StyleAttributes {
        switch self {
        case .solid(let backgroundColor, let foregroundColor):
            let adjustMode: BetterButton.StyleAttributes.HighlightAdjustMode =
                backgroundColor.averageBrightness > StyleConstants.highlightLightenDarkenThreshold ? .darken(by: nil) : .lighten(by: nil)
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
            let adjustMode: BetterButton.StyleAttributes.HighlightAdjustMode =
                foregroundColor.averageBrightness > StyleConstants.highlightLightenDarkenThreshold ? .darken(by: nil) : .lighten(by: nil)
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
