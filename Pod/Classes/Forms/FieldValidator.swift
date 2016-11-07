//
//  FieldValidator.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/25/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

struct FieldValidator {
    let fieldName: String
    let rules: [FieldValidationRule]

    func validate(inputString: String) -> Error? {
        for rule in rules {
            if let error = rule.validate(fieldName: fieldName, inputString: inputString) {
                return error
            }
        }

        return nil
    }
}

protocol FieldValidationRule {
    func validate(fieldName: String, inputString: String) -> Error?
}

typealias CustomRule = (_: String, _: String) -> Error?

enum ValidationRule: FieldValidationRule {
    case nonEmpty
    case minLength(length: Int)
    case validEmail
    case custom(rule: CustomRule)

    func validate(fieldName: String, inputString: String) -> Error? {
        switch self {
        case .nonEmpty where inputString.characters.count == 0:
            return error(with: fieldName)
        case .minLength(let length) where inputString.characters.count < length:
            return error(with: fieldName)
        case .validEmail where !inputString.isValidEmail:
            return error(with: fieldName)
        case .custom(let rule):
            return rule(fieldName, inputString)
        default: return nil
        }
    }

}

extension ValidationRule {

    static let domain = "com.raizlabs.FieldValidationError"

    enum Code: Int {
        case Generic
        case NonEmpty
        case MinLength
        case ValidEmail
        case Custom
    }

    var errorCode: Code {
        switch self {
        case .nonEmpty: return .NonEmpty
        case .minLength(_): return .MinLength
        case .validEmail: return .ValidEmail
        case .custom(_): return .Custom
        }
    }

}

private extension ValidationRule {

    func error(with fieldName: String) -> Error {
        switch self {
        case .nonEmpty:
            return error(
                description: localizedString(key: "%@ is required", fieldName.localizedCapitalized),
                recovery: localizedString(key: "Please enter a valid %@.", fieldName.localizedCapitalized)
            )
        case .minLength(let length):
            return error(
                description: localizedString(key: "%@ is too short", fieldName.localizedCapitalized),
                recovery: localizedString(key: "%@ must be at least %d characters in length.", fieldName.localizedCapitalized, length)
            )
        case .validEmail:
            return error(
                description: localizedString(key: "%@ is not valid", fieldName.localizedCapitalized),
                recovery: localizedString(key: "Please enter a valid %@.", fieldName.localizedCapitalized)
            )
        case .custom:
            fatalError("The error should be provided by the custom rule.")
        }
    }

    func error(description: String, recovery: String) -> Error {
        return NSError(domain: ValidationRule.domain, code: errorCode.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description,
            NSLocalizedRecoverySuggestionErrorKey: recovery
            ])
    }

    func localizedString(key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }

}

private extension String {

    var isValidEmail: Bool {
        // Source: http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

}
