//
//  HairlineView.swift
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

import Foundation

open class HairlineView: UIView {

    #if TARGET_INTERFACE_BUILDER
    @IBInspectable open var axis: Int = 0
    #else
    open var axis: UILayoutConstraintAxis = .horizontal {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }
    #endif

    @IBInspectable open var thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale) {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    @IBInspectable open var hairlineColor: UIColor = UIColor.darkGray {
        willSet {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            newValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            if alpha != 1.0 {
                self.alpha = alpha
                let solid = newValue.withAlphaComponent(1.0)
                self.hairlineColor = solid
            }
        }
        didSet {
            setNeedsDisplay()
        }
    }

    public init(axis: UILayoutConstraintAxis, thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale),
                hairlineColor: UIColor = UIColor.darkGray) {
        self.axis = axis
        self.thickness = thickness
        self.hairlineColor = hairlineColor
        super.init(frame: .zero)

        setNeedsUpdateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValue(forKey: #keyPath(axis)) {
            guard let decodedAxis = UILayoutConstraintAxis(rawValue: aDecoder.decodeInteger(forKey: #keyPath(axis))) else {
                return nil
            }
            axis = decodedAxis
        }
        if aDecoder.containsValue(forKey: #keyPath(thickness)) {
            thickness = CGFloat(aDecoder.decodeFloat(forKey: #keyPath(thickness)))
        }
        if aDecoder.containsValue(forKey: #keyPath(hairlineColor)) {
            guard let decodedHairline = aDecoder.decodeObject(forKey: #keyPath(hairlineColor)) as? UIColor else {
                return nil
            }
            hairlineColor = decodedHairline
        }
        super.init(coder: aDecoder)
        setNeedsUpdateConstraints()
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        hairlineColor.setFill()
        UIRectFill(rect)
    }

    open override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        autoresizingMask.insert([.flexibleHeight, .flexibleWidth])
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(axis.rawValue, forKey: #keyPath(axis))
        aCoder.encode(thickness, forKey: #keyPath(thickness))
        aCoder.encode(hairlineColor, forKey: #keyPath(hairlineColor))
    }

    open override var intrinsicContentSize: CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)

        switch axis {
        case .horizontal: size.height = thickness
        case .vertical: size.width = thickness
        }

        return size
    }

    open override func contentHuggingPriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return (self.axis == axis ? UILayoutPriorityRequired : UILayoutPriorityDefaultLow)
    }

    open override func contentCompressionResistancePriority(for axis: UILayoutConstraintAxis) -> UILayoutPriority {
        return contentHuggingPriority(for: axis)
    }
    
    
}
