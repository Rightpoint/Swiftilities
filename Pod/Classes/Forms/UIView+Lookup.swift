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
    @nonobjc final public func lookupSortedViews<T: UIView>(includeHidden: Bool = false, includeNonInteractable: Bool = false) -> [T] {
        if let view = self as? T {
            if isHidden.equals(false, shouldTest: !includeHidden) &&
                isUserInteractionEnabled.equals(true, shouldTest: !includeNonInteractable) {
                return [view]
            }
        }
        var views: [T] = Array()
        for subview in subviews {
            let results: [T] = subview.lookupSortedViews(includeHidden: includeHidden,
                                                         includeNonInteractable: includeNonInteractable)
            views.append(contentsOf: results)
        }
        views.sort { (view, otherView) -> Bool in
            let center = convert(view.center, from: view.superview)
            let otherCenter = convert(otherView.center, from: otherView.superview)
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

private extension Bool {

    func equals(_ value: Bool, shouldTest: Bool) -> Bool {
        guard shouldTest else {
            return true
        }
        return self == value
    }

}
