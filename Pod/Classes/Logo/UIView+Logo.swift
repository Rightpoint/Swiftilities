//
//  UIView+Logo.swift
//  Pods
//
//  Created by Derek Ostrander on 7/18/16.
//
//

import UIKit

public extension UIView {
    public static func rz_logo(contentMode: UIViewContentMode = .Center, insets: UIEdgeInsets = UIEdgeInsetsZero) -> UIView {
        let image = UIImage(named: "logo-built-by-RZ", inBundle: NSBundle(forClass: Swiftilities.UIView.self), compatibleWithTraitCollection: nil)!.imageWithRenderingMode(.AlwaysTemplate).resizableImageWithCapInsets(insets)
        let logo = UIImageView(image: image)
        logo.contentMode = contentMode
        return logo
    }
}
