//
//  TailoredSwiftTextView.swift
//  Swiftilities
//
//  Created by Derek Ostrander on 6/8/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

open class TailoredSwiftTextView: PlaceholderTextView, HeightAutoAdjustable {
    open weak var animationDelegate: TextViewAnimationDelegate?
    open var animateHeightChange: Bool = true
    open var heightPriority: UILayoutPriority = UILayoutPriority.defaultHigh

    override open var text: String! {
        didSet {
            layoutIfNeeded()
            updateAppearance()
        }
    }

    override open var attributedText: NSAttributedString! {
        didSet {
            layoutIfNeeded()
            updateAppearance()
        }
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        adjustHeight()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adjustHeight()
    }

    override func textDidChange(_ notification: Notification) {
        if let object = notification.object as AnyObject?, object === self {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        adjustHeight()
        adjustPlaceholder()
    }
}
