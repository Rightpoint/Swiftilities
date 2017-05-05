//
//  TableSection.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Foundation

struct TableSection<SectionType, RowType>: RowContainer {

    typealias Row = RowType

    var section: SectionType
    var rows: [RowType]

}

protocol RowContainer {

    associatedtype Row

    var rows: [Row] { get set }

}

extension Collection where Iterator.Element: RowContainer, Self.Index == Int {

    subscript(indexPath indexPath: IndexPath) -> Iterator.Element.Row {
        return self[indexPath.section].rows[indexPath.row]
    }

}
