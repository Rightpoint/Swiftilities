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
    
    func validate(inputString: String) -> ErrorType? {
        for rule in rules {
            if let error = rule.validate(fieldName, inputString: inputString) {
                return error
            }
        }
        
        return nil
    }
}

protocol FieldValidationRule {
    func validate(fieldName: String, inputString: String) -> ErrorType?
}

enum ValidationRule: FieldValidationRule {
    case NonEmpty
    case MinLength(length: Int)
    case ValidEmail
    
    func validate(fieldName: String, inputString: String) -> ErrorType? {
        switch self {
        case NonEmpty where inputString.characters.count == 0:
            return errorWithFieldName(fieldName)
        case MinLength(let length) where inputString.characters.count < length:
            return errorWithFieldName(fieldName)
        case ValidEmail where !inputString.isValidEmail:
            return errorWithFieldName(fieldName)
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
    }
    
    var errorCode: Code {
        switch self {
        case NonEmpty: return .NonEmpty
        case MinLength(_): return .MinLength
        case ValidEmail: return .ValidEmail
        }
    }
    
}

private extension ValidationRule {
    
    func errorWithFieldName(fieldName: String) -> ErrorType {
        switch self {
        case NonEmpty:
            return error(
                localizedString("%@ is required", fieldName.localizedCapitalizedString),
                localizedString("Please enter a valid %@.", fieldName.localizedLowercaseString)
            )
        case MinLength(let length):
            return error(
                localizedString("%@ is too short", fieldName.localizedCapitalizedString),
                localizedString("%@ must be at least %d characters in length.", fieldName.localizedCapitalizedString, length)
            )
        case ValidEmail:
            return error(
                localizedString("%@ is not valid", fieldName.localizedCapitalizedString),
                localizedString("Please enter a valid %@.", fieldName.localizedLowercaseString)
            )
        }
    }
    
    func error(description: String, _ recovery: String) -> ErrorType {
        return NSError(domain: ValidationRule.domain, code: errorCode.rawValue, userInfo: [
            NSLocalizedDescriptionKey: description,
            NSLocalizedRecoverySuggestionErrorKey: recovery
            ])
    }
    
    func localizedString(key: String, _ args: CVarArgType...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
    
}

private extension String {
    
    var isValidEmail: Bool {
        // Source: http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
}
