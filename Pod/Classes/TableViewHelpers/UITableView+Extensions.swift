//
//  UITableView+Extensions.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

extension UITableView {

    func role(ofRow indexPath: IndexPath) -> IndexPath.RowRole {
        let rowsInSection = numberOfRows(inSection: indexPath.section)

        guard rowsInSection != 0 else {
            preconditionFailure("Attempt to assess role of index path in section with zero items")
        }

        guard rowsInSection > 1 else {
            return .only
        }

        switch indexPath.row {
        case 0: return .first
        case rowsInSection - 1: return .last
        default: return .middle
        }
    }

}
