//
//  FieldValidator.swift
//  Swiftilities
//
//  Created by Nicholas Bonatsakis on 5/25/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

public struct ValidationError: Error {

    public let field: String
    public let value: String
    public let validationErrors: [Error]

    public var localizedDescription: String {
        let errorList = validationErrors.map({ $0.localizedDescription }).joined(separator: "\n")
        let format = NSLocalizedString("\"%@\" failed validation for field \"%@\" with the errors:\n%@", comment: "")
        return String.localizedStringWithFormat(format, value, field, errorList)
    }

}

public struct FieldValidator {

    let fieldName: String
    let rules: [FieldValidationRule]

    public init(fieldName: String, rules: [FieldValidationRule]) {
        self.fieldName = fieldName
        self.rules = rules
    }

    public func validate(_ value: String) throws {
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
            throw ValidationError(field: fieldName, value: value, validationErrors: errors)
        }
    }

}

public protocol FieldValidationRule {

    func validate(_ value: String) throws

}

public struct NonEmptyValidator: FieldValidationRule {

    public init() { }

    public func validate(_ value: String) throws {
        if value.isEmpty {
            throw RuleError.empty
        }
    }

}

public struct LengthValidator: FieldValidationRule {

    @available(*, unavailable) public init() {
        fatalError("LengthValidator must be initialized wiht init(rule:).")
    }

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
            guard value.count <= maximum else {
                throw RuleError.aboveMaxmimumLength(maximum)
            }
        }
        if let minimum = allowedMin {
            guard value.count >= minimum else {
                throw RuleError.belowMinimumLength(minimum)
            }
        }
    }

}

public struct DiscreteLengthValidator: FieldValidationRule {
    public var allowedLengths: [Int]

    @available(*, unavailable) public init() {
        fatalError("DiscreteLengthValidator must be initialized with init(allowedLengths:) or init(allowedLength:).")
    }

    public init(allowedLength: Int) {
        self.allowedLengths = [allowedLength]
    }

    public init(allowedLengths: [Int]) {
        self.allowedLengths = allowedLengths
    }

    public func validate(_ value: String) throws {
        let length = value.count
        if !allowedLengths.contains(length) {
            throw RuleError.invalidLength(allowedLengths)
        }
    }
}

public struct EmailValidator: FieldValidationRule {

    public init() { }

    public func validate(_ value: String) throws {
        guard value.isValidEmail else {
            throw RuleError.invalidEmail
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

public enum RuleError: LocalizedError {

    case empty
    case belowMinimumLength(Int)
    case aboveMaxmimumLength(Int)
    case invalidEmail
    case invalidLength([Int])

    public var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("input was not a valid email",
                                     comment: "Field validation error for invalid email")
        case .empty:
            return NSLocalizedString("required input was empty",
                                     comment: "Field validation error for empty required field")
        case .aboveMaxmimumLength(let length):
            let format = NSLocalizedString("field was above the maxmium length of %d",
                                           comment: "Field validation error for a field over the maximum allowed length")
            return String.localizedStringWithFormat(format, length)
        case .belowMinimumLength(let length):
            let format = NSLocalizedString("field was below the minimum length of %d",
                                           comment: "Field validation error for a field under the minimum allowed length")
            return String.localizedStringWithFormat(format, length)
        case .invalidLength(let allowedLengths):
            let format = NSLocalizedString("field was not one of the accepted lengths: %@",
                                           comment: "Field validation error for a field failing to match discrete lengths")
            return String.localizedStringWithFormat(format, allowedLengths.description)

        }
    }

}
