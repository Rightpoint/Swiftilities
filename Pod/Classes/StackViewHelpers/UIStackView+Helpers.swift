//
//  UIStackView+Helpers.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/17/16.
//  Copyright © 2016 Raizlabs. All rights reserved.

import UIKit

public extension UIStackView {

    convenience init(axis: UILayoutConstraintAxis, arrangedSubviews: UIView...) {
        self.init(axis: axis, arrangedSubviews: arrangedSubviews)
    }

    convenience init(axis: UILayoutConstraintAxis, arrangedSubviews: [UIView]) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
    }

    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }

}
