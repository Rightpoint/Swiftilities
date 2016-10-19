//
//  UIView+Lookup.swift
//  Swiftilities
//
//  Created by Brian King on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension UIView {

    /// Lookup the subviews of a specific type, sorted by y position.
    ///
    /// - parameter includeHidden: Return hidden views in the response. The default is false.
    /// - parameter includeNonInteractable: Return views that do not have user interaction enabled. The default is false.
    ///
    /// - returns: An array of views, of type T, sorted by y position.
    @nonobjc final public func lookupSortedViews<T: UIView>(_ includeHidden: Bool = false, includeNonInteractable: Bool = false) -> [T] {
        if let textField = self as? T {
            if (isHidden == false || (includeHidden && isHidden == true)) &&
                (isUserInteractionEnabled == true || includeNonInteractable && isUserInteractionEnabled == false) {
                return [textField]
            }
        }
        var views: [T] = Array()
        for subview in subviews {
            let results: [T] = subview.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
            views.append(contentsOf: results)
        }
        views.sort { (textField, otherTextField) -> Bool in
            let center = convert(textField.center, from: textField.superview)
            let otherCenter = convert(otherTextField.center, from: otherTextField.superview)
            return center.y < otherCenter.y
        }
        return views
    }

    @nonobjc final public func lookupParentView<T: UIView>() -> T? {
        var parent: UIView? = superview
        while parent != nil && parent as? T == nil {
            parent = parent?.superview
        }
        return parent as? T
    }
}
