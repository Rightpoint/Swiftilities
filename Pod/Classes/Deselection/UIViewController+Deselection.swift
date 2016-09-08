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

#if swift(>=3.0)
    private typealias IndexPathType = IndexPath
#else
    private typealias IndexPathType = NSIndexPath
#endif

public extension UIViewController {

    ///  Smoothly deselect selected rows in a table view during an animated
    ///  transition, and intelligently reselect those rows if the interactive
    ///  transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter tableView: The table view in which to perform deselection/reselection.
    func rz_smoothlyDeselectRows(tableView: UITableView?) {
        let selectedIndexPaths = tableView?.indexPathsForSelectedRows ?? []

        let deselectAll: ([IndexPathType], Bool) -> Void = { (selectedIndexPaths, animated) in
            for indexPath in selectedIndexPaths {
                #if swift(>=3.0)
                    tableView?.deselectRow(at: indexPath, animated: animated)
                #else
                    tableView?.deselectRowAtIndexPath(indexPath, animated: animated)
                #endif
            }
        }

        let animation = { (context: UIViewControllerTransitionCoordinatorContext) in
            #if swift(>=3.0)
                deselectAll(selectedIndexPaths, context.isAnimated)
            #else
                deselectAll(selectedIndexPaths, context.isAnimated())
            #endif
        }

        let completion = { (context: UIViewControllerTransitionCoordinatorContext) in
            #if swift(>=3.0)
                if context.isCancelled {
                    for indexPath in selectedIndexPaths {
                        tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
            #else
                if context.isCancelled() {
                    for indexPath in selectedIndexPaths {
                        tableView?.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                    }
                }
            #endif
        }

        #if swift(>=3.0)
            if let coordinator = transitionCoordinator {
            coordinator.animateAlongsideTransition(in: parent?.view, animation: animation, completion: completion)
            }
            else {
            deselectAll(selectedIndexPaths, false)
            }
        #else
            if let coordinator = transitionCoordinator() {
                coordinator.animateAlongsideTransitionInView(parentViewController?.view, animation: animation, completion: completion)

            }
            else {
                deselectAll(selectedIndexPaths, false)
            }
        #endif
    }

    ///  Smoothly deselect selected items in a collection view during an animated
    /// transition, and intelligently reselect those items if the interactive
    /// transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter collectionView: The table view in which to perform deselection/reselection.
    func rz_smoothlyDeselectItems(collectionView: UICollectionView?) {
        #if swift(>=3.0)
            let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []
        #else
            let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() ?? []
        #endif

        let deselectAll: ([IndexPathType], Bool) -> Void = { (selectedIndexPaths, animated) in
            for indexPath in selectedIndexPaths {
                #if swift(>=3.0)
                    collectionView?.deselectItem(at: indexPath, animated: animated)
                #else
                    collectionView?.deselectItemAtIndexPath(indexPath, animated: animated)
                #endif
            }
        }
        let animation = { (context: UIViewControllerTransitionCoordinatorContext) in
            #if swift(>=3.0)
                deselectAll(selectedIndexPaths, context.isAnimated)
            #else
                deselectAll(selectedIndexPaths, context.isAnimated())
            #endif

        }

        let completion = { (context: UIViewControllerTransitionCoordinatorContext) in
            #if swift(>=3.0)
                if context.isCancelled {
                    for indexPath in selectedIndexPaths {
                        collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
                    }
                }

            #else
                if context.isCancelled() {
                    for indexPath in selectedIndexPaths {
                        collectionView?.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
                    }
                }
            #endif
        }

        #if swift(>=3.0)
            if let coordinator = transitionCoordinator {
                coordinator.animateAlongsideTransition(in: parent?.view, animation: animation, completion: completion)
            }
            else {
                deselectAll(selectedIndexPaths, false)
            }
        #else
            if let coordinator = transitionCoordinator() {
                coordinator.animateAlongsideTransitionInView(parentViewController?.view, animation: animation, completion: completion)
            }
            else {
                deselectAll(selectedIndexPaths, false)
            }
        #endif
    }
    
}
