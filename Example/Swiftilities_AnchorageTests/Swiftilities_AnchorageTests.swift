//
//  Swiftilities_AnchorageTests.swift
//  Swiftilities_AnchorageTests
//
//  Created by Chris Ballinger on 3/29/18.
//  Copyright © 2018 Raizlabs. All rights reserved.
//

import XCTest
import Anchorage
import Swiftilities



private class TestView: UIView {
    let button = UIButton()

    override func layoutSubviews() {
        super.layoutSubviews()

        let cgfloat: CGFloat = 24
        let float = 24.0
        let int: Int = 24

        var inferredCGFloat = DeviceSize.adjust(
            74.0,
            for: [.small: cgfloat]
        )
        inferredCGFloat += 1
        inferredCGFloat += 1.0

        var explicitCGFloat2: CGFloat = DeviceSize.adjust(
            74.0,
            for: [.small: cgfloat]
        )
        explicitCGFloat2 += 1.0

        var explicitCGFloat = DeviceSize.adjust(
            CGFloat(74.0),
            for: [.small: cgfloat]
        )
        explicitCGFloat += 1
        explicitCGFloat += 1.0

        var inferredFloat = DeviceSize.adjust(
            74.0,
            for: [.small: 25.0]
        )
        inferredFloat += 1
        inferredFloat += 1.0


        var inferredIntegers = DeviceSize.adjust(
            74,
            for: [.small: 75]
        )
        inferredIntegers += 1

        button.bottomAnchor == bottomAnchor + DeviceSize.adjust(
            74,
            for: [.small: 25.0])
        button.bottomAnchor == bottomAnchor + DeviceSize.adjust(
            74,
            for: [.small: float])

        button.bottomAnchor == bottomAnchor + DeviceSize.adjust(
            CGFloat(74),
            for: [.small: float])
        button.bottomAnchor == bottomAnchor + DeviceSize.adjust(
            CGFloat(74),
            for: [.small: cgfloat])
        button.bottomAnchor == bottomAnchor + CGFloat(DeviceSize.adjust(
            CGFloat(74),
            for: [.small: cgfloat]))
        button.bottomAnchor == bottomAnchor + CGFloat(DeviceSize.adjust(
            CGFloat(74),
            for: [.small: CGFloat(55)]))
        button.bottomAnchor == bottomAnchor + DeviceSize.adjust(
            1,
            for: [.small: CGFloat(55)])
        button.bottomAnchor == bottomAnchor + explicitCGFloat

        // should this be allowed?
        let out = DeviceSize.adjust("cool", for: [.small: 24])
        let out2 = DeviceSize.adjust("cool", for: [.small: UIView()])

        print("what type am i \(out) \(out2)")
    }
}

class Swiftilities_AnchorageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCompileOnXcode93_Swift41() {



    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
