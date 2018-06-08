//
//  AcknowledgementsListViewModel.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

private struct AcknowlegmentConstants {
    static let settingsKeyTitle = "Title"
    static let settingsKeySpecifiers = "PreferenceSpecifiers"
    static let settingsKeyFooterText = "FooterText"
}

public struct AcknowledgementsListViewModel {

    public enum AcknowledgementsError: Error {
        case missingPlistNamed(String)
        case invalidPlistAtURL(URL)
        case noTitle
        case noSpecifiers
    }

    public var title: String
    public var acknowledgements: [AcknowledgementViewModel]

}

public extension AcknowledgementsListViewModel {

    public init(plistNamed plistName: String = "Acknowledgements", in bundle: Bundle = Bundle.main) throws {
        guard let url = bundle.url(forResource: plistName, withExtension: "plist") else {
            throw AcknowledgementsError.missingPlistNamed(plistName)
        }
        let dictionary = try AcknowledgementsListViewModel.loadPlist(at: url)
        title = try AcknowledgementsListViewModel.parseTitle(from: dictionary)
        acknowledgements = try AcknowledgementsListViewModel.parseAcknowledgements(from: dictionary)
    }

    public init(plistURL: URL) throws {
        let dictionary = try AcknowledgementsListViewModel.loadPlist(at: plistURL)
        title = try AcknowledgementsListViewModel.parseTitle(from: dictionary)
        acknowledgements = try AcknowledgementsListViewModel.parseAcknowledgements(from: dictionary)
    }

}

private extension AcknowledgementsListViewModel {

    static func loadPlist(at url: URL) throws -> [String: Any] {
        guard let dictionary = NSDictionary(contentsOf: url) as? [String: Any] else {
            throw AcknowledgementsError.invalidPlistAtURL(url)
        }
        return dictionary
    }

    static func parseTitle(from dictionary: [String: Any]) throws -> String {
        guard let title = dictionary[AcknowlegmentConstants.settingsKeyTitle] as? String else {
            throw AcknowledgementsError.noTitle
        }
        return title
    }

    static func parseAcknowledgements(from dictionary: [String: Any]) throws -> [AcknowledgementViewModel] {
        guard let specifiers = dictionary[AcknowlegmentConstants.settingsKeySpecifiers] as? [[String: Any]] else {
            throw AcknowledgementsError.noSpecifiers
        }
        guard specifiers.count > 2 else {
            return []
        }
        // First and last elements in the settings bundle are not needed (title and empty row).
        // these are broken up to speed up compile times
        let innerRange = 1..<(specifiers.count - 1)
        #if swift(>=4.1)
        let rawAcknowledgements = specifiers[innerRange].compactMap(AcknowledgementViewModel.init(dictionary:))
        #else
        let rawAcknowledgements = specifiers[innerRange].flatMap(AcknowledgementViewModel.init(dictionary:))
        #endif
        let acknowledgements = rawAcknowledgements.sorted {
            return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }

        return acknowledgements
    }

}

public struct AcknowledgementViewModel {
    public let title: String
    public let license: String
}

private extension AcknowledgementViewModel {

    init?(dictionary: [String: Any]) {
        guard let title = dictionary[AcknowlegmentConstants.settingsKeyTitle] as? String,
            let footerText = dictionary[AcknowlegmentConstants.settingsKeyFooterText] as? String else {
                return nil
        }
        self.title = title
        self.license = footerText.cleanedUpLicense
    }
}
