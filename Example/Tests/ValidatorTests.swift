//
//  ValidatorTests.swift
//  Swiftilities
//
//  Created by Zev Eisenberg on 1/18/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Swiftilities
import XCTest

class ValidatorTests: XCTestCase {

    func testNonEmpty() throws {
        let validator = FieldValidator(fieldName: "firstName", rules: [
            NonEmptyValidator(),
            ])

        try validator.validate("something")

        do {
            try validator.validate("")
        }
        catch let error as ValidationError {
            XCTAssertEqual((error as NSError).domain, "Swiftilities.ValidationError")
            XCTAssertEqual(error.localizedDescription, "\"\" failed validation for field \"firstName\" with the errors:\nrequired input was empty")
            let subErrors = error.validationErrors
            XCTAssertEqual(subErrors.count, 1)

            if let first: RuleError = subErrors.first as? RuleError, case .empty = first {
                // test passes
            }
            else {
                XCTFail("Expected 1 error of type .empty, but got \(subErrors)")
            }
        }
        catch let otherError {
            XCTFail("Got unexpected error: \(otherError)")
        }
    }

    func testMinLength() throws {
        let validator = FieldValidator(fieldName: "state", rules: [
            LengthValidator(rule: .greaterThanOrEqual(2)),
            ])

        try validator.validate("ABC")

        do {
            try validator.validate("A")
        }
        catch let error as ValidationError {
            XCTAssertEqual((error as NSError).domain, "Swiftilities.ValidationError")
            XCTAssertEqual(error.localizedDescription, "\"A\" failed validation for field \"state\" with the errors:\nfield was below the minimum length of 2")
            let subErrors = error.validationErrors
            XCTAssertEqual(subErrors.count, 1)

            if let first: RuleError = subErrors.first as? RuleError, case .belowMinimumLength(let targetLength) = first {
                XCTAssertEqual(targetLength, 2)
            }
            else {
                XCTFail("Expected 1 error of type .belowMinimumLength, but got \(subErrors)")
            }
        }
        catch let otherError {
            XCTFail("Got unexpected error: \(otherError)")
        }
    }

    func testValidEmail() throws {
        let validator = FieldValidator(fieldName: "email", rules: [
            EmailValidator(),
            ])

        try validator.validate("test@raizlabs.com")
        try validator.validate("test+foo@raizlabs.com")

        do {
            try validator.validate("A")
        }
        catch let error as ValidationError {
            XCTAssertEqual((error as NSError).domain, "Swiftilities.ValidationError")
            XCTAssertEqual(error.localizedDescription, "\"A\" failed validation for field \"email\" with the errors:\ninput was not a valid email")
            let subErrors = error.validationErrors
            XCTAssertEqual(subErrors.count, 1)

            if let first: RuleError = subErrors.first as? RuleError, case .invalidEmail = first {
                // test passes
            }
            else {
                XCTFail("Expected 1 error of type .invalidEmail, but got \(subErrors)")
            }
        }
        catch let otherError {
            XCTFail("Got unexpected error: \(otherError)")
        }

        var didError = false
        do {
            try validator.validate("test!!$%@test.com")
        }
        catch {
            didError = true
        }
        XCTAssertTrue(didError)
    }

    func testMulti() throws {
        let validator = FieldValidator(fieldName: "email", rules: [
            NonEmptyValidator(),
            EmailValidator(),
            ])

        try validator.validate("test@raizlabs.com")

        do {
            try validator.validate("")
        }
        catch let error as ValidationError {
            XCTAssertEqual((error as NSError).domain, "Swiftilities.ValidationError")
            XCTAssertEqual(error.localizedDescription, "\"\" failed validation for field \"email\" with the errors:\nrequired input was empty\ninput was not a valid email")
            let subErrors = error.validationErrors
            XCTAssertEqual(subErrors.count, 2)

            if let first: RuleError = subErrors.first as? RuleError, case .empty = first {
                // test passes
            }
            else {
                XCTFail("Expected 2 errors: .empty and .invalidEmail, but got \(subErrors)")
            }
        }
        catch let otherError {
            XCTFail("Got unexpected error: \(otherError)")
        }

        do {
            try validator.validate("foo")
        }
        catch let error as ValidationError {
            XCTAssertEqual((error as NSError).domain, "Swiftilities.ValidationError")
            XCTAssertEqual(error.localizedDescription, "\"foo\" failed validation for field \"email\" with the errors:\ninput was not a valid email")
            let subErrors = error.validationErrors
            XCTAssertEqual(subErrors.count, 1)

            if let first: RuleError = subErrors.first as? RuleError, case .invalidEmail = first {
                // test passes
            }
            else {
                XCTFail("Expected 1 .empty, but got \(subErrors)")
            }
        }
        catch let otherError {
            XCTFail("Got unexpected error: \(otherError)")
        }
    }

}
