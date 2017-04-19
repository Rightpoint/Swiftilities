//
//  IndexPath+Extensions.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Swiftilities. All rights reserved.
//

import Foundation

extension IndexPath {

    /// The role that a table view cell plays in a table view section.
    enum RowRole {

        /// This cell is the only one in its section.
        case only

        /// This cell is the first row in its section.
        case first

        /// This cell is not the first first, last, or only row in its section.
        case middle

        /// This cell is the last row in its section.
        case last

    }

}
