//
//  TintedButton.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

/// A button that looks and behaves like the default "Get" button in iTunes
/// To fully replacate the effect in views built in interface builder, the button type needs to be set to "custom"
open class TintedButton: UIButton {

    @IBInspectable open var fillColor: UIColor = UIColor.clear {
        didSet {
            setupBackground()
        }
    }

    @IBInspectable open var textColor: UIColor? = nil {
        didSet {
            setupTint()
        }
    }

    @IBInspectable open var buttonCornerRadius: CGFloat = 4 {
        didSet {
            setupBorder()
        }
    }

    @IBInspectable open var buttonBorderWidth: CGFloat = 1 {
        didSet {
            setupBorder()
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            toggleBackground()
        }
    }

    public init(fillColor: UIColor, textColor: UIColor, buttonCornerRadius: CGFloat = 4.0, buttonBorderWidth: CGFloat = 1.0) {
        super.init(frame: CGRect.zero)
        self.fillColor = fillColor
        self.textColor = textColor
        self.buttonCornerRadius = buttonCornerRadius
        self.buttonBorderWidth = buttonBorderWidth
        setupBackground()
        setupTint()
    }

    public required init?(coder aDecoder: NSCoder) {
        if let color = aDecoder.decodeObject(forKey: #keyPath(fillColor)) as? UIColor {
            self.fillColor = color
        }
        if let color = aDecoder.decodeObject(forKey: #keyPath(tintColor)) as? UIColor {
            self.textColor = color
        }
        super.init(coder: aDecoder)
        setupBackground()
        setupTint()
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(fillColor, forKey: #keyPath(fillColor))
        aCoder.encode(textColor, forKey: #keyPath(textColor))
    }

}

private extension TintedButton {

    func setupBackground() {
        setTitleColor(fillColor, for: .highlighted)
        toggleBackground()
    }

    func toggleBackground() {
        if isHighlighted {
            backgroundColor = textColor
        }
        else {
            backgroundColor = fillColor
        }
    }

    func setupTint() {
        setTitleColor(textColor, for: .normal)
        layer.borderColor = self.textColor?.cgColor
        toggleBackground()
        setupBorder()
    }

    func setupBorder() {
        layer.borderWidth = buttonBorderWidth
        layer.cornerRadius = buttonCornerRadius
    }
}
