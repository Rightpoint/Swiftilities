//
//  LocalLogHandler.swift
//  Swiftilities
//
//  Created by Justin Magnini on 5/27/21.
//

import Foundation

public protocol LogEntry {
    /// Category of the Log where this entry was originated from
    var category: String {get}

    /// Log level of entry.
    var level: Log.Level {get}

    /// Message sent by Log.
    var message: String {get}

    /// When Log entry was received
    var timestamp: Date {get}
}

extension LogEntry {
    public func matches(query: String) -> Bool {
        (message.range(of: query, options: .regularExpression)?.isEmpty ?? true) == false
    }
}

/// A handler to collect Log messages locally, and allow for searching and filtering.
open class LocalLogHandler {

    /// Basic implementation of the LogEntry protocol
    struct Entry: LogEntry {
        /// Category of the Log where this entry was originated from
        var category: String

        /// Log level of entry.
        var level: Log.Level

        /// Message sent by Log.
        var message: String

        /// When Log entry was received
        var timestamp: Date
    }

    /// Maximum number of Log entries that may be collected.
    public var size: UInt = 1000

    private var entries: [LogEntry] = []

    // MARK: Initializer

    public init(size: UInt = 1000) {
        self.size = size
    }

    // MARK: Public Methods

    /// Intended to be called from the Log.globalHandler to record Log messages.
    public func addEntry(log: Log, level: Log.Level, string: String) {
        addEntry(Entry(category: log.name, level: level, message: string, timestamp: Date()))
    }

    /// Intended to be called from the Log.globalHandler to record Log messages.
    public func addEntry(_ entry: LogEntry) {
        entries.append(entry)
        while entries.count > size {
            entries.remove(at: 0)
        }
    }

    /// Remove all entries
    public func removeAllEntries() {
        entries.removeAll()
    }

    /// Returns all entries captured by the LocalLogHandler raw, and unfiltered
    public func allEntries() -> [LogEntry] {
        return entries
    }

    /**
        Filters all log entries, only returning those that match the given criteria

     - parameter category: If non-nill, entry must have come from a Log with this category.
     - parameter level: If non-nill, minimum level for a log entry.

     - returns: A filtered listed of `LogEntry` elements that match the criteria.
     */
    public func getEntries(_ category: String, level: Log.Level? = nil) -> [LogEntry] {
        return getEntries(categories: [category], level: level)
    }

    /**
        Filters all log entries, only returning those that match the given criteria

     - parameter categories: If non-nill, entry must have come from a Log with one of these category.
     - parameter level: If non-nill, minimum level for a log entry.

     - returns: A filtered listed of `LogEntry` elements that match the criteria.
     */
    public func getEntries(categories: [String]? = nil, level: Log.Level? = nil) -> [LogEntry] {
        return entries.filter {
            if !(categories?.contains($0.category) ?? true) {
                return false
            }

            if $0.level.rawValue < level?.rawValue ?? 0 {
                return false
            }

            return true
        }
    }

    /**
        Searches for log entries that match the provided query.

     - parameter query: Regular Expression search query.

     - returns: A filtered listed of `LogEntry` elements that match the query.
     */
    public func search(_ query: String) -> [LogEntry] {
        return entries.filter {
            ($0.message.range(of: query, options: .regularExpression)?.isEmpty ?? true) == false
        }
    }

    /// Exports Data containing a UTF8 summary of all collected Log entries.
    public func export() -> Data {
        var log: String = ""
        entries.forEach {
            log += $0.message + "\n"
        }
        return Data(log.utf8)
    }
}
