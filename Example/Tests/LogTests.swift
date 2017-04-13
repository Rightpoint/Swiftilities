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

        var loggedStrings: [String] = []
        Log.handler = { string in
            loggedStrings.append(string)
        }

        Log.logLevel = .warn

        Log.verbose("Ignore me")
        Log.error("Don't ignore me!")

        // Log messages include the date, which is not conducive to testing,
        // so we just check the end of the logged string.
        XCTAssertEqual(loggedStrings.count, 1)
        XCTAssertTrue(loggedStrings[0].hasSuffix("Don't ignore me!"))
    }

}
