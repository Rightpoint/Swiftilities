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

public extension UIViewController {

    ///  Smoothly deselect selected rows in a table view during an animated
    ///  transition, and intelligently reselect those rows if the interactive
    ///  transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter tableView: The table view in which to perform deselection/reselection.
    func rz_smoothlyDeselectRows(tableView tableView: UITableView?) {
        let selectedIndexPaths = tableView?.indexPathsForSelectedRows ?? []

        if let coordinator = transitionCoordinator() {
                selectedIndexPaths.forEach {
                    tableView?.deselectRowAtIndexPath($0, animated: context.isAnimated())
            coordinator.animateAlongsideTransition({ context in
                }
                }, completion: { context in
                    if context.isCancelled() {
                        selectedIndexPaths.forEach {
                            tableView?.selectRowAtIndexPath($0, animated: false, scrollPosition: .None)
                        }
                    }
            })
        }
        else {
            selectedIndexPaths.forEach {
                tableView?.deselectRowAtIndexPath($0, animated: false)
            }
        }
    }

    ///  Smoothly deselect selected items in a collection view during an animated
    /// transition, and intelligently reselect those items if the interactive
    /// transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter collectionView: The table view in which to perform deselection/reselection.
    func rz_smoothlyDeselectItems(collectionView collectionView: UICollectionView?) {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems() ?? []

        if let coordinator = transitionCoordinator() {
                selectedIndexPaths.forEach {
                    collectionView?.deselectItemAtIndexPath($0, animated: context.isAnimated())
            coordinator.animateAlongsideTransition({ context in
                }
                }, completion: { context in
                    if context.isCancelled() {
                        selectedIndexPaths.forEach {
                            collectionView?.selectItemAtIndexPath($0, animated: false, scrollPosition: .None)
                        }
                    }
            })
        }
        else {
            selectedIndexPaths.forEach {
                collectionView?.deselectItemAtIndexPath($0, animated: false)
            }
        }
    }
    
}