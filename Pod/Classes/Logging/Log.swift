//
//  Log.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 2/5/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//
// Copyright 2016 Raizlabs and other contributors
// http://raizlabs.com/

import Foundation


#if swift(>=3.0)
    /**
    *  A simple log that outputs to the console via ```print()````
    *  Includes support for XcodeColors (can also install using alcatraz)
    *  https://github.com/robbiehanson/XcodeColors
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
        }
        
        /// The log level, defaults to .Off
        open static var logLevel: Level = .off
        
        /// If true, prints text in color in accordance with the Xcode log color plug-in.
        open static var printColoredText: Bool = false

        
        // MARK: Private
        
        fileprivate struct Cmd {
            static let esc = "\u{001b}["
            static let resetFG = esc + "fg;"
            static let resetBG = esc + "bg;"
            static let reset = esc + ";"
        }
        
        fileprivate struct Color {
            static let red = Cmd.esc + "fg240,0,0;"
            static let yellow = Cmd.esc + "fg200,200,0;"
            static let green = Cmd.esc + "fg0,150,0;"
        }
        
        fileprivate static func log<T>(_ object: T, level: Level, color: String, _ fileName: String, _ functionName: String, _ line: Int) {
            if logLevel.rawValue <= level.rawValue {
                let logColor = Log.printColoredText ? color : ""
                let components:[String] = fileName.components(separatedBy: "/")
                let objectName = components.last ?? "Unknown Object"
                print( logColor + "\(Date())|\(level.name().uppercased())|\(objectName) \(functionName) line \(line): " + Cmd.reset + "\(object)")
            }
        }
        
        // MARK: Log Methods
        
        static open func error<T>(_ object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.error, color: Color.red, fileName, functionName, line)
        }

        open static func warn<T>(_ object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.warn, color: Color.yellow, fileName, functionName, line)
        }

        open static func info<T>(_ object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.info, color: Color.green, fileName, functionName, line)
        }

        open static func debug<T>(_ object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.debug, color: Color.green, fileName, functionName, line)
        }

        open static func verbose<T>(_ object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.verbose, color: Color.green, fileName, functionName, line)
        }

    }
#else
    /**
     *  A simple log that outputs to the console via ```print()````
     *  Includes support for XcodeColors (can also install using alcatraz)
     *  https://github.com/robbiehanson/XcodeColors
     */
    public class Log {

        // MARK: Configuration

        /**
         Represents a level of detail to be logged.
         */
        public enum Level : Int {
            case Verbose
            case Debug
            case Info
            case Warn
            case Error
            case Off

            func name() -> String {
                switch(self) {
                case .Verbose: return "Verbose"
                case .Debug: return "Debug"
                case .Info: return "Info"
                case .Warn: return "Warn"
                case .Error: return "Error"
                case .Off: return "Disabled"
                }
            }
        }

        /// The log level, defaults to .Off
        public static var logLevel: Level = .Off

        /// If true, prints text in color in accordance with the Xcode log color plug-in.
        public static var printColoredText: Bool = false


        // MARK: Private

        private struct Cmd {
            static let esc = "\u{001b}["
            static let resetFG = esc + "fg;"
            static let resetBG = esc + "bg;"
            static let reset = esc + ";"
        }

        private struct Color {
            static let red = Cmd.esc + "fg240,0,0;"
            static let yellow = Cmd.esc + "fg200,200,0;"
            static let green = Cmd.esc + "fg0,150,0;"
        }

        private static func log<T>(object: T, level: Level, color: String, _ fileName: String, _ functionName: String, _ line: Int) {
            if logLevel.rawValue <= level.rawValue {
                let logColor = Log.printColoredText ? color : ""
                let components:[String] = fileName.componentsSeparatedByString("/")
                let objectName = components.last ?? "Unknown Object"
                print( logColor + "\(NSDate())|\(level.name().uppercaseString)|\(objectName) \(functionName) line \(line): " + Cmd.reset + "\(object)")
            }
        }

        // MARK: Log Methods

        static public func error<T>(object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.Error, color: Color.red, fileName, functionName, line)
        }

        public static func warn<T>(object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.Warn, color: Color.yellow, fileName, functionName, line)
        }

        public static func info<T>(object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.Info, color: Color.green, fileName, functionName, line)
        }

        public static func debug<T>(object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.Debug, color: Color.green, fileName, functionName, line)
        }

        public static func verbose<T>(object: T, _ fileName: String = #file, _ functionName: String = #function, _ line: Int = #line) {
            log(object, level:.Verbose, color: Color.green, fileName, functionName, line)
        }
        
    }
#endif
