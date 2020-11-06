//
//  TableSection.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public struct TableSection<SectionType, RowType>: RowContainer {

    public typealias Row = RowType

    public var section: SectionType
    public var rows: [RowType]

    public init(section: SectionType, rows: [RowType]) {
        self.section = section
        self.rows = rows
    }

}

public protocol RowContainer {

    associatedtype Row

    var rows: [Row] { get set }

}

public extension Collection where Element: RowContainer, Self.Index == Int {

    subscript(indexPath indexPath: IndexPath) -> Iterator.Element.Row {
        return self[indexPath.section].rows[indexPath.row]
    }

}

#endif
