//
//  UIView+Logo.swift
//  Pods
//
//  Created by Derek Ostrander on 7/18/16.
//
//

import UIKit

public extension UIView {
    private class RZBundle {} // to grab the image url
    public static func rz_logo() -> UIImageView {
        guard let url = NSBundle(forClass: RZBundle.self).URLForResource("logo-built-by-RZ", withExtension: "png"),
            let path = url.path,
            let image = UIImage(contentsOfFile: path) else { fatalError("Can't find the rz logo in the bundle.") }
        let logo = UIImageView(image: image)
        logo.contentMode = .ScaleAspectFit
        return logo
    }
}
