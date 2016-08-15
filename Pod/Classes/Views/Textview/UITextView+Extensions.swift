//
//  UITextView+Extensions.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit

extension PlaceholderConfigurable where Self:UITextView {
    private func xConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .Left &&
                    constraint.secondAttribute == .Left &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            })
            .first ?? placeholderLabel.leftAnchor.constraintEqualToAnchor(leftAnchor)
        constraint.active = true

        return constraint
    }

    private func yConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .Top &&
                    constraint.secondAttribute == .Top &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            }).first ?? placeholderLabel.topAnchor.constraintEqualToAnchor(topAnchor)
        constraint.active = true

        return constraint
    }

    var placeholderConstraints: OriginConstraints {
        return (xConstraint(), yConstraint())
    }

    var placeholderPosition: CGPoint {
        guard let range = textRangeFromPosition(beginningOfDocument, toPosition: beginningOfDocument) else {
            return CGPointZero
        }

        let rect = firstRectForRange(range)
        return CGPoint(x:rect.origin.x, y:rect.origin.y)
    }

    func adjustPlaceholder() {
        placeholderLabel.hidden = text.characters.count > 0

        let position = placeholderPosition
        placeholderConstraints.x?.constant = position.x
        placeholderConstraints.y?.constant = position.y
    }
}

extension HeightAutoAdjustable where Self:UITextView {
    private var bottomOffset: CGPoint {
        let verticalInset =  abs(textContainerInset.top - textContainerInset.bottom)
        return CGPoint(x: 0.0,
                       y: contentSize.height - CGRectGetHeight(self.bounds) + verticalInset)
    }

    var intrinsicContentHeight: CGFloat {
        let height = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.max)).height
        guard let font = font else {
            return height
        }

        let minimum = textContainerInset.top + self.textContainerInset.bottom + font.lineHeight
        return max(height, minimum)
    }
    
    // Attempts to find the apporpriate constraint and creates one if needed.
    func heightConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .Height &&
                    constraint.firstItem === self &&
                    constraint.active &&
                    constraint.multiplier == 1.0
            }).first ?? heightAnchor.constraintEqualToConstant(intrinsicContentHeight)

        if !constraint.active {
            constraint.priority = heightPriority
            constraint.active = true
            setNeedsLayout()
        }

        return constraint
    }

    func adjustHeight(animated: Bool) {
        let height = intrinsicContentHeight
        guard height > 0 && heightConstraint().constant != height else { return }
        heightConstraint().constant = height

        setNeedsLayout()

        // this is (most likely) the right view to animate to make for a smooth animation.
        // TODO: Make a delegate callback to get the view to be animating.
        guard let container = superview?.superview where animated else {
            scrollToBottom(animated)
            return
        }

        UIView.animateWithDuration(0.1, animations: {
            container.layoutIfNeeded()
            if self.bottomOffset.y < (self.font?.lineHeight ?? 0.0) {
                self.scrollToBottom(animated)
            }
        })
    }

    func scrollToBottom(animated: Bool) {
        setContentOffset(bottomOffset, animated: animated)
    }
}
