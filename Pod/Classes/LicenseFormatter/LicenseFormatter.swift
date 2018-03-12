//
//  LicenseFormatter.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 11/18/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

extension String {

    @nonobjc public var cleanedUpLicense: String {
        // add an extra new line between list items
        return self.newlinePaddedLists.collapsedArtificialLineBreaks.collapsedDoubleNewLines
    }

}

internal extension String {

    @nonobjc var newlinePaddedLists: String {
        let lineBreakRegexString = "(?<=[^\\n\\r])[\\n\\r][^\\S\\r\\n]*([(?:\\d.)\\*•-])"

        let output: String
        do {
            let regex = try NSRegularExpression(pattern: lineBreakRegexString, options: [])
            output = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: count), withTemplate: "\n\n$1")
        }
        catch(let error) {
            preconditionFailure("Invalid regular expression string: '\(lineBreakRegexString)', error: \(error)")
        }

        return output
    }

    @nonobjc var collapsedArtificialLineBreaks: String {
        // (?<=\\S): look-behind assertion: non-whitespace character
        // \\n: a new line
        // [^\\S\\r\\n]: none of: non-whitespace, carriage return, new line. Matches all horizontal whitespace.
        // *: the previous set zero or more times (i.e. leading indentation on the line)
        // (?=\\S): look-ahead assertion: non-whitespace character
        let lineBreakRegexString = "(?<=\\S)\\n[^\\S\\r\\n]*(?=\\S)"

        let output: String
        do {
            let regex = try NSRegularExpression(pattern: lineBreakRegexString, options: [])
            output = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: count), withTemplate: " ")
        }
        catch(let error) {
            preconditionFailure("Invalid regular expression string: '\(lineBreakRegexString)', error: \(error)")
        }

        return output
    }

    @nonobjc var collapsedDoubleNewLines: String {
        let doubleNewlineRegexString = "([\n\r])[\n\r]"

        let output: String
        do {
            let regex = try NSRegularExpression(pattern: doubleNewlineRegexString, options: [])
            output = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: count), withTemplate: "$1")
        }
        catch(let error) {
            preconditionFailure("Invalid regular expression string: '\(doubleNewlineRegexString)', error: \(error)")
        }

        return output
    }

}
