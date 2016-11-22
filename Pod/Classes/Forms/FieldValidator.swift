//
//  FieldValidator.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/25/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public enum ValidationError: Error {

    case failed(field: String, value: String, validationErrors: [Error])

    public var field: String {
        let field: String
        switch self {
        case .failed(field: let failedField, value: _, validationErrors: _):
            field = failedField
        }
        return field
    }

    public var value: String {
        let value: String
        switch self {
        case .failed(field: _, value: let failedValue, validationErrors: _):
            value = failedValue
        }
        return value
    }

    public var validationErrors: [Error] {
        let validationErrors: [Error]
        switch self {
        case .failed(field: _, value: _, validationErrors: let failedErrors):
            validationErrors = failedErrors
        }
        return validationErrors
    }

    public var localizedDescription: String {
        let errorList = validationErrors.map({ $0.localizedDescription }).joined(separator: "\n")
        let format = NSLocalizedString("\"%@\" failed validation for field \"%@\" with the errors:\n%@", comment: "")
        return String.localizedStringWithFormat(format, value, field, errorList)
    }

}

public struct FieldValidator {

    let fieldName: String
    let rules: [FieldValidationRule]

    func validate(_ value: String) throws {
        var errors = [Error]()
        for rule in rules {
            do {
                try rule.validate(value)
            }
            catch {
                errors.append(error)
            }
        }
        guard errors.isEmpty else {
            throw ValidationError.failed(field: fieldName, value: value, validationErrors: errors)
        }
    }

}

public protocol FieldValidationRule {

    func validate(_ value: String) throws

}

public struct NonEmptyValidator: FieldValidationRule {

    public func validate(_ value: String) throws {
        if value.isEmpty {
            throw RuleErrors.shouldNotBeEmpty
        }
    }

}

public struct LengthValidator: FieldValidationRule {

    public enum LengthRule {
        case lessThanOrEqual(Int), greaterThanOrEqual(Int), betweenOrEqual(minimum: Int, maximum: Int)
    }

    public var rule: LengthRule

    public init(rule: LengthRule) {
        self.rule = rule
    }

    public func validate(_ value: String) throws {
        let allowedMin: Int?
        let allowedMax: Int?
        switch rule {
        case .lessThanOrEqual(let maximum):
            allowedMax = maximum
            allowedMin = nil
        case .greaterThanOrEqual(let minimum):
            allowedMax = nil
            allowedMin = minimum
        case .betweenOrEqual(minimum: let minimum, maximum: let maximum):
            allowedMax = maximum
            allowedMin = minimum
        }
        if let maximum = allowedMax {
            guard value.characters.count <= maximum else {
                throw RuleErrors.aboveMaxmimumLength(maximum)
            }
        }
        if let minimum = allowedMin {
            guard value.characters.count >= minimum else {
                throw RuleErrors.belowMinimumLength(minimum)
            }
        }
    }

}

public struct EmailValidatior: FieldValidationRule {

    public func validate(_ value: String) throws {
        guard value.isValidEmail else {
            throw RuleErrors.invalidEmail
        }
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

public enum RuleErrors: Error {

    case shouldNotBeEmpty
    case belowMinimumLength(Int)
    case aboveMaxmimumLength(Int)
    case invalidEmail

    public var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("input was not a valid email",
                                     comment: "Field validation error for invalid email")
        case .shouldNotBeEmpty:
            return NSLocalizedString("required input was empty",
                                     comment: "Field validation error for empty required field")
        case .aboveMaxmimumLength(let length):
            let format = NSLocalizedString("Field was above maxmium length of %d",
                                           comment: "Field validation error for a field over the maximum allowed length")
            return String.localizedStringWithFormat(format, length)
        case .belowMinimumLength(let length):
            let format = NSLocalizedString("Field was below the minimum length of %d",
                                           comment: "Field validation error for a field under the minimum allowed length")
            return String.localizedStringWithFormat(format, length)
        }
    }

}
