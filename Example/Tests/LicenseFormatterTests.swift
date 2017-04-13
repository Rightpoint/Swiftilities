//
//  LicenseFormatterTests.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 11/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

@testable import Swiftilities
import XCTest

class StringTest: XCTestCase {

    func testNewLinePadding() {
        let originalString = "line 1\n" +
            "line 2\n" +
            "\n" +
            "line 3\n" +
            "\n" +
            "1. a list with\n" +
            "   indented stuff\n" +
            "2. another list with\n" +
        "   more indented stuff"

        let controlString = "line 1\n" +
            "line 2\n" +
            "\n" +
            "line 3\n" +
            "\n" +
            "1. a list with\n" +
            "   indented stuff\n" +
            "\n" +
            "2. another list with\n" +
        "   more indented stuff"

        let testString = originalString.newlinePaddedLists

        XCTAssertEqual(testString, controlString)
    }

    func testCollapseArtificialLineBreaks() {
        let originalString = "line 1\nline 2\n\nline 3\n\n1. a list with\n   indented stuff"
        let controlString = "line 1 line 2\n\nline 3\n\n1. a list with indented stuff"

        let testString = originalString.collapsedArtificialLineBreaks

        XCTAssertEqual(testString, controlString)
    }

    func testCollapseDoubleNewlines() {
        let originalString = "line 1 line 2\n\nline 3\n\n1. a list with indented stuff\n\n\nand a triple"
        let controlString = "line 1 line 2\nline 3\n1. a list with indented stuff\n\nand a triple"

        let testString = originalString.collapsedDoubleNewLines

        XCTAssertEqual(testString, controlString)
    }

    func testLicenceTidying() {
        let originalString = "line 1\nline 2\n\nline 3\n\n1. a list with\n   indented stuff\n2. another list with\n   more indented stuff"
        let controlString = "line 1 line 2\nline 3\n1. a list with indented stuff\n2. another list with more indented stuff"

        let testString = originalString.cleanedUpLicense

        XCTAssertEqual(testString, controlString)
    }

    func testLicenceTidyingWithAlternateBulletPoints() {
        let originalString = "line 1\nline 2\n\nline 3\n\n1 a list with\n   indented stuff\n- another list with\n   more indented stuff\n• another bulleted item\n* and another\n123 one more"
        let controlString = "line 1 line 2\nline 3\n1 a list with indented stuff\n- another list with more indented stuff\n• another bulleted item\n* and another\n123 one more"

        let testString = originalString.cleanedUpLicense

        XCTAssertEqual(testString, controlString)
    }

}
