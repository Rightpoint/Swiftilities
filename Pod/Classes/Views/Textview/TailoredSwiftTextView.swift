//
//  TailoredSwiftTextView.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit

#if swift(>=3.0)

    open class TailoredSwiftTextView: PlaceholderTextView, HeightAutoAdjustable {
        open var animationDelegate: TextViewAnimationDelegate?
        open var animateHeightChange: Bool = true
        open var heightPriority: UILayoutPriority = UILayoutPriorityDefaultHigh

        override open var text: String! {
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
            if (notification.object as AnyObject) === self {
                adjustHeight()
                adjustPlaceholder()
            }
        }

        private func updateAppearance() {
            adjustHeight()
            adjustPlaceholder()
        }
    }

#else

    public class TailoredSwiftTextView: PlaceholderTextView, HeightAutoAdjustable {
        public var animationDelegate: TextViewAnimationDelegate?
        public var animateHeightChange: Bool = true
        public var heightPriority: UILayoutPriority = UILayoutPriorityDefaultHigh

        override public var text: String! {
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

        override func textDidChange(notification: NSNotification) {
            if notification.object === self {
                updateAppearance()
            }
        }

        private func updateAppearance() {
            adjustHeight()
            adjustPlaceholder()
        }
    }

#endif
