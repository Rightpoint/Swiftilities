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

protocol HeightAutoAdjustable {
    var heightPriority: UILayoutPriority { get }
    var heightConstraint: NSLayoutConstraint { get }
    var intrinsicContentHeight: CGFloat { get }

    func adjustHeight(animated: Bool)
}
