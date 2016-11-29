//
//  Log.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
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
    public enum Level: Int {
        case verbose
        case debug
        case info
        case warn
        case error
        case off

        var name: String {
            switch self {
            case .verbose: return "Verbose"
            case .debug: return "Debug"
            case .info: return "Info"
            case .warn: return "Warn"
            case .error: return "Error"
            case .off: return "Disabled"
            }
        }

        var emoji: String {
            switch self {
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
    public static var logLevel: Level = .off

    /// If true, prints emojis to signify log type, defaults to off
    public static var useEmoji: Bool = false

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
            let levelString = Log.useEmoji ? level.emoji : "|" + level.name.uppercased() + "|"
            print("\(levelString)\(date) \(objectName) \(functionName) line \(line):\n\(object())\n")
        }
    }

    // MARK: Log Methods

    public static func error<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.error, fileName, functionName, line)
    }

    public static func warn<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.warn, fileName, functionName, line)
    }

    public static func info<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.info, fileName, functionName, line)
    }

    public static func debug<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.debug, fileName, functionName, line)
    }

    public static func verbose<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object, level:.verbose, fileName, functionName, line)
    }
}
