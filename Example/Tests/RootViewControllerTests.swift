//
//  RootViewControllerTests.swift
//  Swiftilities
//
//  Created by Michael Skiba on 2/22/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

#if canImport(UIKit)
import UIKit
import Swiftilities
import XCTest

class RootViewControllerTests: XCTestCase {

    var demoWindow: UIWindow = UIWindow()

    override func setUp() {
        super.setUp()
        demoWindow = UIWindow()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCompletionAnimatedFromEmpty() {
        let expect = expectation(description: "Completion handler should be executed")
        let completion = { expect.fulfill() }
        demoWindow.setRootViewController(UIViewController(), animated: true, completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCompletionNonAnimatedFromEmpty() {
        let expect = expectation(description: "Fist completion handler should fire")
        let completion = { expect.fulfill() }
        demoWindow.setRootViewController(UIViewController(), animated: false, completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCompletionAnimated() {
        demoWindow.rootViewController = UIViewController()
        let expect = expectation(description: "Completion handler should be executed")
        let completion = { expect.fulfill() }
        demoWindow.setRootViewController(UIViewController(), animated: true, completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCompletionNonAnimated() {
        demoWindow.rootViewController = UIViewController()
        let expect = expectation(description: "Completion handler should be executed")
        let completion = { expect.fulfill() }
        demoWindow.setRootViewController(UIViewController(), animated: false, completion: completion)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}

#endif
