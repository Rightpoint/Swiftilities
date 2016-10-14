//
//  Protocols.swift
//  Pods
//
//  Created by Derek Ostrander on 6/8/16.
//
//

import UIKit

typealias OriginConstraints = (x: NSLayoutConstraint?, y: NSLayoutConstraint?)

protocol PlaceholderConfigurable {
    var placeholderLabel: UILabel { get }
    var placeholderPosition: CGPoint { get }
    var placeholderConstraints: OriginConstraints { get }

    func adjustPlaceholder()
}

public protocol TextViewAnimationDelegate {
    /// Whether or not the given UITextView should animate its height changes.
    /// - Parameter textView: The UITextView that should or should not have the changes to its height animated.
    /// - Returns: Whether or not changes to the height of the UITextView will be animated.
    #if swift(>=3.0)
    func shouldAnimateHeightChange(_ textView: UITextView) -> Bool
    #else
    func shouldAnimateHeightChange(textView: UITextView) -> Bool
    #endif

    /// Gets the container view that will call `setNeedsLayout` in order to animate the given UITextView. Should be a parent of `textView`, but if not, the call will have no effect. Will also have no effect if `shouldAnimateHeightChange` returns false.
    /// - Parameter textView: The UITextView whose height is to be changed.
    /// - Returns: The UIView responsible for animating layout changes by laying out its subviews.
    func containerToLayout(forTextView textView: UITextView) -> UIView?

    /// Gets the animation duration for when `textView` changes height. Value is not used if `shouldAnimateHeightChange` returns false.
    /// - Parameter textView: The UITextView whose height is to be changed.
    /// - Returns: The duration of the animation, in seconds.
    #if swift(>=3.0)
    func animationDuration(_ textView: UITextView) -> TimeInterval?
    #else
    func animationDuration(textView: UITextView) -> NSTimeInterval?
    #endif
}

protocol HeightAutoAdjustable {
    var animationDelegate: TextViewAnimationDelegate? { get set }
    var heightPriority: UILayoutPriority { get }
    var intrinsicContentHeight: CGFloat { get }

    func heightConstraint() -> NSLayoutConstraint
    func adjustHeight()
}
