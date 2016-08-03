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
    public func rz_sortedSubviews<T: UIView>(ofType type: T.Type, includeHidden: Bool = false, includeNonInteractable: Bool = false) -> [T] {
        if let view = self as? T {
            if (hidden == false || (includeHidden && hidden == true)) &&
                (userInteractionEnabled == true || includeNonInteractable && userInteractionEnabled == false) {
                return [view]
            }
        }
        var views: [T] = Array()
        for subview in subviews {
            let results = subview.rz_sortedSubviews(ofType: T.self, includeHidden: includeHidden, includeNonInteractable: includeNonInteractable)
            views.appendContentsOf(results)
        }
        views.sortInPlace { (view, otherView) -> Bool in
            let center = convertPoint(view.center, fromView: view.superview)
            let otherCenter = convertPoint(otherView.center, fromView: otherView.superview)
            return center.y < otherCenter.y
        }
        return views
    }

    public func rz_nearestSuperview<T: UIView>(ofType type: T.Type) -> T? {
        var parent: UIView? = superview
        while parent != nil && parent as? T == nil {
            parent = parent?.superview
        }
        return parent as? T
    }
}
