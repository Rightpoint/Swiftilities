//
//  UITextView+Extensions.swift
//  Swiftilities
//
//  Created by Derek Ostrander on 6/8/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension PlaceholderConfigurable where Self: UITextView {
    fileprivate func xConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .left &&
                    constraint.secondAttribute == .left &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            })
            .first ?? placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor)
        constraint.isActive = true

        return constraint
    }

    fileprivate func yConstraint() -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = constraints
            .filter({ (constraint: NSLayoutConstraint) -> Bool in
                return constraint.firstAttribute == .top &&
                    constraint.secondAttribute == .top &&
                    (constraint.firstItem === self || constraint.secondItem === self)
            }).first ?? placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
        constraint.isActive = true

        return constraint
    }

    var placeholderConstraints: OriginConstraints {
        return (xConstraint(), yConstraint())
    }

    var placeholderPosition: CGPoint {
        return CGPoint(x: textContainerInset.left + textContainer.lineFragmentPadding,
                       y: textContainerInset.top)
    }

    func adjustPlaceholder() {
        placeholderLabel.isHidden = text.count > 0

        let position = placeholderPosition
        placeholderConstraints.x?.constant = position.x
        placeholderConstraints.y?.constant = position.y
    }
}

extension HeightAutoAdjustable where Self: UITextView {
    fileprivate var bottomOffset: CGPoint {
        let verticalInset = abs(textContainerInset.top - textContainerInset.bottom)
        return CGPoint(x: 0.0,
                       y: contentSize.height - self.bounds.height + verticalInset)
    }

    var intrinsicContentHeight: CGFloat {
        let height = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
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
                return constraint.firstAttribute == .height &&
                    constraint.firstItem === self &&
                    constraint.isActive &&
                    constraint.multiplier == 1.0
            }).first ?? heightAnchor.constraint(equalToConstant: intrinsicContentHeight)

        if !constraint.isActive {
            constraint.priority = heightPriority
            constraint.isActive = true
            setNeedsLayout()
        }

        return constraint
    }

    func adjustHeight() {
        let height = intrinsicContentHeight
        guard height > 0 && heightConstraint().constant != height else { return }
        heightConstraint().constant = height

        setNeedsLayout()

        let animated = animationDelegate?.shouldAnimateHeightChange(self) ?? false
        guard let container = animationDelegate?.containerToLayout(forTextView: self), animated else {
            scrollToBottom(animated)
            return
        }

        let duration = animationDelegate?.animationDuration(self) ?? 0.1
        UIView.animate(withDuration: duration, animations: {
            container.layoutIfNeeded()
            if self.bottomOffset.y < (self.font?.lineHeight ?? 0.0) {
                self.scrollToBottom(animated)
            }
        })
    }

    func scrollToBottom(_ animated: Bool) {
        setContentOffset(bottomOffset, animated: animated)
    }
}
