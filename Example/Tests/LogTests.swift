//
//  LogTests.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 4/13/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import XCTest

class LogTests: XCTestCase {

    func testLogHandler() {

        var loggedStrings: [(level: Log.Level, string: String)] = []
        Log.handler = { (level, string) in
            loggedStrings.append((level: level, string: string))
        }

        Log.logLevel = .warn

        Log.verbose("Ignore me")
        Log.error("Don't ignore me!")

        // Log messages include the date, which is not conducive to testing,
        // so we just check the end of the logged string.
        XCTAssertEqual(loggedStrings.count, 1)
        XCTAssertEqual(loggedStrings[0].level, .error)
        XCTAssertTrue(loggedStrings[0].string.hasSuffix("Don't ignore me!"))
    }

}
