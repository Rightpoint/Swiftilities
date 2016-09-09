//
//  UIView+Lookup.swift
//  Swiftilities
//
//  Created by Brian King on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

extension UIView {

    #if swift(>=3.0)
    /// Lookup the subviews of a specific type, sorted by y position.
    ///
    /// - parameter includeHidden: Return hidden views in the response. The default is false.
    /// - parameter includeNonInteractable: Return views that do not have user interaction enabled. The default is false.
    ///
    /// - returns: An array of views, of type T, sorted by y position.
        public func lookupSortedViews<T: UIView>(_ includeHidden: Bool = false, includeNonInteractable: Bool = false) -> [T] {
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

        public func lookupNextView<T: UIView>(_ currentView: T, includeHidden: Bool = false, includeNonInteractable: Bool = false) -> T? {
            let views: [T] = self.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
            guard let index = views.index(of: currentView) else { return nil }
            let nextIndex = (index + 1)
            return (views.indices.contains(nextIndex)) ? views[nextIndex] : nil
        }

        public func lookupPreviousView<T: UIView>(_ currentView: T, includeHidden: Bool = false, includeNonInteractable: Bool = false) -> T? {
            let views: [T] = self.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
            guard let index = views.index(of: currentView) else { return nil }
            let previousIndex = index - 1
            return (views.indices.contains(previousIndex)) ? views[previousIndex] : nil
        }

        public func lookupParentView<T: UIView>() -> T? {
            var parent: UIView? = superview
            while parent != nil && parent as? T == nil {
                parent = parent?.superview
            }
            return parent as? T
        }
    #else
    /// Lookup the subviews of a specific type, sorted by y position.
    ///
    /// - parameter includeHidden: Return hidden views in the response. The default is false.
    /// - parameter includeNonInteractable: Return views that do not have user interaction enabled. The default is false.
    ///
    /// - returns: An array of views, of type T, sorted by y position.
        public func lookupSortedViews<T: UIView>(includeHidden: Bool = false, includeNonInteractable: Bool = false) -> [T] {
            if let textField = self as? T {
                if (hidden == false || (includeHidden && hidden == true)) &&
                    (userInteractionEnabled == true || includeNonInteractable && userInteractionEnabled == false) {
                    return [textField]
                }
            }
            var views: [T] = Array()
            for subview in subviews {
                let results: [T] = subview.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
                views.appendContentsOf(results)
            }
            views.sortInPlace { (textField, otherTextField) -> Bool in
                let center = convertPoint(textField.center, fromView: textField.superview)
                let otherCenter = convertPoint(otherTextField.center, fromView: otherTextField.superview)
                return center.y < otherCenter.y
            }
            return views
        }

        public func lookupNextView<T: UIView>(currentView: T, includeHidden: Bool = false, includeNonInteractable: Bool = false) -> T? {
            let views: [T] = self.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
            guard let index = views.indexOf(currentView) else { return nil }
            let nextIndex = index.successor()
            return (views.indices.contains(nextIndex)) ? views[nextIndex] : nil
        }

        public func lookupPreviousView<T: UIView>(currentView: T, includeHidden: Bool = false, includeNonInteractable: Bool = false) -> T? {
            let views: [T] = self.lookupSortedViews(includeHidden, includeNonInteractable: includeNonInteractable)
            guard let index = views.indexOf(currentView) else { return nil }
            let previousIndex = index.predecessor()
            return (views.indices.contains(previousIndex)) ? views[previousIndex] : nil
        }

        public func lookupParentView<T: UIView>() -> T? {
            var parent: UIView? = superview
            while parent != nil && parent as? T == nil {
                parent = parent?.superview
            }
            return parent as? T
        }
    #endif
}
