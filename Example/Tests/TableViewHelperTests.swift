//
//  TableViewHelperTests.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/19/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import Swiftilities
import XCTest

enum Row {

    case title
    case body
    case image

}

final class TableViewTester: NSObject {

    let tableView = UITableView()

    let sections: [TableSection<String, Row>]

    init(sections: [TableSection<String, Row>]) {
        self.sections = sections
        super.init()
        tableView.dataSource = self
    }

}

extension TableViewTester: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

}

class TableViewHelperTests: XCTestCase {

    let sections = [
        TableSection(section: "Section 0", rows: [
            Row.title,
            .image,
            .body,
            .image,
            .body,
            .body,
            ]),
        TableSection(section: "Section 1", rows: [
            .image,
            .image,
            .image,
            ]),
        TableSection(section: "Section 2", rows: [
            .title,
            ]),
        ]

    func testTableSection() {
        XCTAssertEqual(sections[0].section, "Section 0")
        XCTAssertEqual(sections[1].section, "Section 1")
        XCTAssertEqual(sections[2].section, "Section 2")
        XCTAssertEqual(sections[indexPath: IndexPath(row: 0, section: 0)], .title)
        XCTAssertEqual(sections[indexPath: IndexPath(row: 5, section: 0)], .body)
        XCTAssertEqual(sections[indexPath: IndexPath(row: 0, section: 1)], .image)
        XCTAssertEqual(sections[indexPath: IndexPath(row: 2, section: 1)], .image)
        XCTAssertEqual(sections[indexPath: IndexPath(row: 0, section: 2)], .title)
    }

    func testIndexPathRoleFromTable() {
        let tester = TableViewTester(sections: sections)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 0, section: 0)), .first)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 1, section: 0)), .middle)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 2, section: 0)), .middle)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 3, section: 0)), .middle)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 4, section: 0)), .middle)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 5, section: 0)), .last)

        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 0, section: 1)), .first)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 1, section: 1)), .middle)
        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 2, section: 1)), .last)

        XCTAssertEqual(tester.tableView.role(ofRow: IndexPath(row: 0, section: 2)), .only)
    }

    func testIndexPathRoleFromIndexPath() {
        XCTAssertEqual(IndexPath(row: 0, section: 0).role(inSectionWithNumberOfRows: 6), .first)
        XCTAssertEqual(IndexPath(row: 1, section: 0).role(inSectionWithNumberOfRows: 6), .middle)
        XCTAssertEqual(IndexPath(row: 2, section: 0).role(inSectionWithNumberOfRows: 6), .middle)
        XCTAssertEqual(IndexPath(row: 3, section: 0).role(inSectionWithNumberOfRows: 6), .middle)
        XCTAssertEqual(IndexPath(row: 4, section: 0).role(inSectionWithNumberOfRows: 6), .middle)
        XCTAssertEqual(IndexPath(row: 5, section: 0).role(inSectionWithNumberOfRows: 6), .last)

        XCTAssertEqual(IndexPath(row: 0, section: 1).role(inSectionWithNumberOfRows: 3), .first)
        XCTAssertEqual(IndexPath(row: 1, section: 1).role(inSectionWithNumberOfRows: 3), .middle)
        XCTAssertEqual(IndexPath(row: 2, section: 1).role(inSectionWithNumberOfRows: 3), .last)

        XCTAssertEqual(IndexPath(row: 0, section: 2).role(inSectionWithNumberOfRows: 1), .only)
    }


}

#endif
