//
//  UIViewController+Deselection.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 5/13/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

public protocol SmoothlyDeselectableItems {
    var indexPathsForSelectedItems: [IndexPath]? { get }
    func selectItem(at indexPath: IndexPath?, animated: Bool)
    func deselectItem(at indexPath: IndexPath, animated: Bool)
}

extension UITableView: SmoothlyDeselectableItems {
    @nonobjc public var indexPathsForSelectedItems: [IndexPath]? { return indexPathsForSelectedRows }

    @nonobjc public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }

    @nonobjc public func deselectItem(at indexPath: IndexPath, animated: Bool) {
        deselectRow(at: indexPath, animated: animated)
    }
}

extension UICollectionView: SmoothlyDeselectableItems {
    @nonobjc public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition())
    }
}

public extension UIViewController {

    ///  Smoothly deselect selected rows in a table view during an animated
    ///  transition, and intelligently reselect those rows if the interactive
    ///  transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter deselectable: The (de)selectable view in which to perform deselection/reselection.
    func smoothlyDeselectItems(_ deselectable: SmoothlyDeselectableItems?) {
        let selectedIndexPaths = deselectable?.indexPathsForSelectedItems ?? []

        if let coordinator = transitionCoordinator {
            coordinator.animateAlongsideTransition(in: parent?.view, animation: { context in
                selectedIndexPaths.forEach {
                    deselectable?.deselectItem(at: $0, animated: context.isAnimated)
                }
                }, completion: { context in
                    if context.isCancelled {
                        selectedIndexPaths.forEach {
                            deselectable?.selectItem(at: $0, animated: false)
                        }
                    }
            })
        }
        else {
            selectedIndexPaths.forEach {
                deselectable?.deselectItem(at: $0, animated: false)
            }
        }
    }
}
