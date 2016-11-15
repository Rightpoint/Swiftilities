//
//  Log.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation


/**
*  A simple log that outputs to the console via ```print()````
*/
open class Log {
    
    // MARK: Configuration
    
    /**
     Represents a level of detail to be logged.
     */
    public enum Level : Int {
        case verbose
        case debug
        case info
        case warn
        case error
        case off
        
        func name() -> String {
            switch(self) {
            case .verbose: return "Verbose"
            case .debug: return "Debug"
            case .info: return "Info"
            case .warn: return "Warn"
            case .error: return "Error"
            case .off: return "Disabled"
            }
        }

        func emoji() -> String {
            switch(self) {
            case .verbose: return "📖"
            case .debug: return "🐝"
            case .info: return "✏️"
            case .warn: return "⚠️"
            case .error: return "⁉️"
            case .off: return ""
            }
        }
    }

    /// The log level, defaults to .Off
    open static var logLevel: Level = .off
    
    /// If true, prints text in color in accordance with the Xcode log color plug-in.
    open static var printColoredText: Bool = false

    /// If true, prints emojis to signify log type, defaults to off
    open static var useEmoji: Bool = false

    // MARK: Private

    /// Date formatter for log
    fileprivate static let dateformatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "Y-MM-dd H:m:ss.SSSS"
        return df
    }()

    /// Generic log method
    fileprivate static func log<T>(_ object: @autoclosure () -> T, level: Log.Level, _ fileName: String, _ functionName: String, _ line: Int) {
        if logLevel.rawValue <= level.rawValue {
            let date = Log.dateformatter.string(from: Date())
            let components: [String] = fileName.components(separatedBy: "/")
            let objectName = components.last ?? "Unknown Object"
            let levelString = Log.useEmoji ? level.emoji() : "|" + level.name().uppercased() + "|"
            print("\(levelString)\(date) \(objectName) \(functionName) line \(line):\n\(object())\n")
        }
    }

    /// Generic log method
    fileprivate static func log<T>(_ object: @autoclosure () -> T, level: Log.Level, _ fileName: String, _ functionName: String, _ line: Int) {
        if logLevel.rawValue <= level.rawValue {
            let date = Log.dateformatter.string(from: Date())
            let components: [String] = fileName.components(separatedBy: "/")
            let objectName = components.last ?? "Unknown Object"
            let levelString = Log.useEmoji ? level.emoji() : "|" + level.name().uppercased() + "|"
            print("\(levelString)\(date) \(objectName) \(functionName) line \(line):\n\(object())\n")
        }
    }

    // MARK: Log Methods
    
    open static func error<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.error, fileName, functionName, line)
    }

    open static func warn<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.warn, fileName, functionName, line)
    }

    open static func info<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.info, fileName, functionName, line)
    }

    open static func debug<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.debug, fileName, functionName, line)
    }

    open static func verbose<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.verbose, fileName, functionName, line)
    }
}
