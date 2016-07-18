//
//  UIView+Logo.swift
//  Pods
//
//  Created by Derek Ostrander on 7/18/16.
//
//

import UIKit

extension UIView {
    static func rz_logo(contentMode: UIViewContentMode = .Center, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
        let image = UIImage(named: "logo-built-by-RZ")!.resizableImageWithCapInsets(insets)
        let logo = UIImageView(image: image)
        logo.contentMode = contentMode
        return logo
    }
}
