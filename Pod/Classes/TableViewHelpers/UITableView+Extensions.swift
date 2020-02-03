//
//  UITableView+Extensions.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension UITableView {

    func role(ofRow indexPath: IndexPath) -> IndexPath.RowRole {
        let rowsInSection = numberOfRows(inSection: indexPath.section)

        return indexPath.role(inSectionWithNumberOfRows: rowsInSection)
    }

}

#endif
