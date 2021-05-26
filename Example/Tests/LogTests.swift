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

    final class Loggers {
        static let userInterface = Log("UI", logLevel: .verbose)
        static let app = Log("App")
    }

    class NetworkLog: Log {
        static var networkLog = Log("Network")

        override class var instance: Log {
            return networkLog
        }
    }

    func testLogHandler() {

        var loggedStrings: [(level: Log.Level, string: String)] = []
        Log.globalHandler = { (log, level, string) in
            loggedStrings.append((level: level, string: string))
        }

        var networkStrings: [(level: Log.Level, string: String)] = []
        NetworkLog.handler = { (level, string) in
            networkStrings.append((level: level, string: string))
        }

        let localInstance = Log("Local Instance", logLevel: .verbose, useEmoji: true)

        Log.logLevel = .info
        Log.useEmoji = true
        Log.verbose("Ignore me")
        Log.error("Don't ignore me!")

        NetworkLog.logLevel = .info
        NetworkLog.verbose("network verbose")
        NetworkLog.debug("network debug")
        NetworkLog.info("network info")
        NetworkLog.warn("network warning")
        NetworkLog.error("network error")

        localInstance.warn("Local Instance Warning")
        Loggers.userInterface.info("Button Pressed")
        Loggers.app.warn("Out of Memory")

        // Log messages include the date, which is not conducive to testing,
        // so we just check the end of the logged string.
        XCTAssertEqual(loggedStrings.count, 6)
        XCTAssertEqual(loggedStrings[0].level, .error)
        XCTAssertTrue(loggedStrings[0].string.hasSuffix("Don't ignore me!"))
        XCTAssertTrue(loggedStrings[1].string.hasSuffix("network info"))
        XCTAssertEqual(networkStrings.count, 3)
    }
}
