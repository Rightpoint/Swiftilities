//
//  Log.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation
import os

/**
*  A simple log that outputs to the console via `print()` and also logs to the console with OSLog (if available)
*/
open class Log {

    // MARK: Types

    public typealias InstanceLogHandler = ((Level, String) -> Void)
    public typealias GlobalLogHandler = ((Log, Level, String) -> Void)

    /**
     Represents a level of detail to be logged.
     */
    public enum Level: Int, CaseIterable {
        case verbose
        case trace
        case debug
        case info
        case warn
        case error
        case off

        public var name: String {
            switch self {
            case .verbose: return "Verbose"
            case .trace: return "Trace"
            case .debug: return "Debug"
            case .info: return "Info"
            case .warn: return "Warn"
            case .error: return "Error"
            case .off: return "Disabled"
            }
        }

        public var emoji: String {
            switch self {
            case .verbose: return "📖"
            case .trace: return "🪧"
            case .debug: return "🐝"
            case .info: return "✏️"
            case .warn: return "⚠️"
            case .error: return "⁉️"
            case .off: return ""
            }
        }
    }

    /// Represents the OSSignpostType when sending trace messages to instruments
    public enum TraceType {
        case begin
        case end
        case event
    }

    public static private(set) var shared = Log("Log", logLevel: .off)

    /// Static instance used for helper methods.
    open class var instance: Log {
        return shared
    }

    /// Subsystem of the OSLog message when running on iOS 14 or later.
    open var subsystem: String {
        let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return (bundleName ?? "com.rightpoint.swiftilities") + ".log"
    }

    /// If this is non-nil, we will call it with the same string that we
    /// are going to print to the console. You can use this to pass log
    /// messages along to your crash reporter, analytics service, etc.
    /// - warning: Be mindful of private user data that might end up in
    ///            your log statements! Use log levels appropriately
    ///            to keep private data out of logs that are sent over
    ///            the Internet.
    public static var globalHandler: GlobalLogHandler?

    // MARK: Configuration

    /// Displayed name of the Log instance, also used as the Category in OSLog messages
    public var name: String

    /// The log level, defaults to .Off
    public var logLevel: Level = .off

    /// If true, prints emojis to signify log type, defaults to off
    public var useEmoji: Bool = false

    /// If this is non-nil, we will call it with the same string that we
    /// are going to print to the console. You can use this to pass log
    /// messages along to your crash reporter, analytics service, etc.
    /// - warning: Be mindful of private user data that might end up in
    ///            your log statements! Use log levels appropriately
    ///            to keep private data out of logs that are sent over
    ///            the Internet.
    public var handler: InstanceLogHandler?

    // MARK: Initializer
    
    required public init(_ name: String, logLevel: Level = .off, useEmoji: Bool = false) {
        self.name = name
        self.logLevel = logLevel
        self.useEmoji = useEmoji
    }

    // MARK: Private

    /// Date formatter for log
    fileprivate static let dateformatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "Y-MM-dd H:m:ss.SSSS"
        return df
    }()

    /// Generic log method
    internal func log<T>(_ object: @autoclosure () -> T, level: Log.Level, _ fileName: String, _ functionName: String, _ line: Int) {
        guard logLevel.rawValue <= level.rawValue else {return}

        let date = Log.dateformatter.string(from: Date())
        let components: [String] = fileName.components(separatedBy: "/")
        let objectName = components.last ?? "Unknown Object"
        let levelString = useEmoji ? level.emoji : "|" + level.name.uppercased() + "|"
        let logString = "\(levelString)\(date) \(objectName) \(functionName) line \(line):\n\(object())"

        if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            let objectString = "\(object())"
            let logMessage = "\(objectName) \(functionName) line \(line)"
            osLog(logMessage, objectString: objectString, level: level)
        }
        else {
            let nameString = name.count > 0 ? "[\(name)]" : ""
            print(nameString + logString + "\n")
        }
        self.handler?(level, logString)
        Log.globalHandler?(self, level, logString)
    }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    internal func osLog(_ logMessage: String, objectString: String, level: Level) {
        let logger = Logger(subsystem: subsystem, category: name)
        switch level {
        case .trace, .verbose:
            logger.trace("\(logMessage):\n\(objectString)")
        case .debug:
            logger.debug("\(logMessage):\n\(objectString)")
        case .info:
            logger.info("\(logMessage):\n\(objectString)")
        case .warn:
            logger.warning("\(logMessage):\n\(objectString)")
        case .error:
            logger.error("\(logMessage):\n\(objectString)")
        case .off:
            break
        }
    }

    @available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
    internal func osSignpost(_ name: StaticString, type: TraceType) {
        let log = OSLog(subsystem: subsystem, category: self.name)
        switch type {
        case .begin:
            os_signpost(.begin, log: log, name: name)
        case .end:
            os_signpost(.end, log: log, name: name)
        case .event:
            os_signpost(.event, log: log, name: name)
        }
    }

    // MARK: Public

    public func error<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object(), level:.error, fileName, functionName, line)
    }

    public func warn<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object(), level:.warn, fileName, functionName, line)
    }

    public func info<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object(), level:.info, fileName, functionName, line)
    }

    public func debug<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object(), level:.debug, fileName, functionName, line)
    }

    public func verbose<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log(object(), level:.verbose, fileName, functionName, line)
    }

    public func trace(_ name: StaticString, type: TraceType = .event, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        log("Trace: \(name)", level: .trace, fileName, functionName, line)
        if #available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *) {
            osSignpost(name, type: type)
        }
    }
}

// MARK: Static Helper Methods
extension Log {

    public static var logLevel: Level {
        get { instance.logLevel }
        set { instance.logLevel = newValue }
    }

    public static var useEmoji: Bool {
        get { instance.useEmoji }
        set { instance.useEmoji = newValue }
    }

    public static var handler: InstanceLogHandler? {
        get { instance.handler }
        set { instance.handler = newValue }
    }

    public static func error<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.log(object(), level:.error, fileName, functionName, line)
    }

    public static func warn<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.log(object(), level:.warn, fileName, functionName, line)
    }

    public static func info<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.log(object(), level:.info, fileName, functionName, line)
    }

    public static func debug<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.log(object(), level:.debug, fileName, functionName, line)
    }

    public static func verbose<T>(_ object: @autoclosure () -> T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.log(object(), level:.verbose, fileName, functionName, line)
    }

    public static func trace(_ name: StaticString, type: TraceType = .event, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
        instance.trace(name, type: type, fileName, functionName, line)
    }
}
