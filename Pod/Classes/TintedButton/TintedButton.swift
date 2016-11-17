//
//  TintedButton.swift
//  Pods
//
//  Created by Michael Skiba on 11/17/16.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
