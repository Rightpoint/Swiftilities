//
//  TailoredSwiftTextView.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit

public class TailoredSwiftTextView: PlaceholderTextView, HeightAutoAdjustable {
    public var animationDelegate: TextViewAnimationDelegate?
    public var animateHeightChange: Bool = true
    public var heightPriority: UILayoutPriority = UILayoutPriorityDefaultHigh

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        adjustHeight()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        adjustHeight()
    }

    override func textDidChange(notification: NSNotification) {
        if notification.object === self {
            adjustHeight()
            adjustPlaceholder()
        }
    }
}
