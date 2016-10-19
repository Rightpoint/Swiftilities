//
//  TailoredSwiftTextView.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit

open class TailoredSwiftTextView: PlaceholderTextView, HeightAutoAdjustable {
    open var animationDelegate: TextViewAnimationDelegate?
    open var animateHeightChange: Bool = true
    open var heightPriority: UILayoutPriority = UILayoutPriorityDefaultHigh

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
            adjustHeight()
            adjustPlaceholder()
        }
    }
}
