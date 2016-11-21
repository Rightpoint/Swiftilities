//
//  AcknowledgementsViewModel.swift
//  Swiftilities
//
//  Created by Michael Skiba on 11/21/16.
//  Copyright © 2016 Raizlabs Inc. All rights reserved.
//

import Foundation

private struct AcknowlegmentConstants {
    static let settingsKeyTitle = "Title"
    static let settingsKeySpecifiers = "PreferenceSpecifiers"
    static let settingsKeyFooterText = "FooterText"
}

public struct AcknowledgementsViewModel {

    public enum AcknowledgementsError: Error {
        case missingPlistNamed(String)
        case invalidPlistAtURL(URL)
        case noTitle
        case noSpecifiers
    }

    public var title: String
    public var acknowledgements: [AcknowledgementViewModel]

}

public extension AcknowledgementsViewModel {

    public init(pListNamed pListName: String = "Acknowledgements", in bundle: Bundle = Bundle.main) throws {
        guard let url = bundle.url(forResource: pListName, withExtension: "plist") else {
            throw AcknowledgementsError.missingPlistNamed(pListName)
        }
        let dictionary = try AcknowledgementsViewModel.loadPlist(at: url)
        title = try AcknowledgementsViewModel.parseTitle(from: dictionary)
        acknowledgements = try AcknowledgementsViewModel.parseAcknowledgements(from: dictionary)
    }

    public init(pListURL: URL) throws {
        let dictionary = try AcknowledgementsViewModel.loadPlist(at: pListURL)
        title = try AcknowledgementsViewModel.parseTitle(from: dictionary)
        acknowledgements = try AcknowledgementsViewModel.parseAcknowledgements(from: dictionary)
    }

}

private extension AcknowledgementsViewModel {

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
        let acknowledgements = specifiers.suffix(from: 1).dropLast().flatMap(AcknowledgementViewModel.init(dictionary:))
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
