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

        let handler = LocalLogHandler()
        
        var loggedStrings: [(level: Log.Level, string: String)] = []
        Log.globalHandler = { (log, level, string) in
            handler.addEntry(log: log, level: level, string: string)
            loggedStrings.append((level: level, string: string))
        }

        var networkStrings: [(level: Log.Level, string: String)] = []
        NetworkLog.handler = { (level, string) in
            networkStrings.append((level: level, string: string))
        }

        let localInstance = Log("Local Instance", logLevel: .verbose, useEmoji: true)

        Log.logLevel = .trace
        Log.useEmoji = true

        Log.trace("tests", type: .begin)
        Log.verbose("Ignore me")
        Log.error("Don't ignore me!")

        NetworkLog.logLevel = .info
        NetworkLog.verbose("network verbose")
        NetworkLog.debug("network debug")
        NetworkLog.info("network info")
        NetworkLog.warn("Network warning")
        NetworkLog.error("network ERROR!")

        localInstance.warn("Local Instance Warning")
        Loggers.userInterface.info("Button Pressed")
        Loggers.userInterface.info("Button Released")
        Loggers.app.warn("Out of Memory")

        Log.trace("tests", type: .end)

        // Log messages include the date, which is not conducive to testing,
        // so we just check the end of the logged string.
        XCTAssertEqual(loggedStrings.count, 9)
        XCTAssertEqual(loggedStrings[1].level, .error)
        XCTAssertTrue(loggedStrings[1].string.hasSuffix("Don't ignore me!"))
        XCTAssertTrue(loggedStrings[2].string.hasSuffix("network info"))
        XCTAssertEqual(networkStrings.count, 3)

        XCTAssertEqual(handler.getEntries(level: .error).count, 2)
        XCTAssertEqual(handler.getEntries("Network", level: .error).count, 1)
        XCTAssertEqual(handler.search("Button").count, 2)
    }
}
