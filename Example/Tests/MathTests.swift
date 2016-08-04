import XCTest
import Swiftilities

class MathTests: XCTestCase {

    func testDoubleScale() {

        let epsilon = 0.00001

        XCTAssertEqualWithAccuracy(1.0.scale(from: 0.0...1.0, to: 0.0...1.0), 1.0, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(0.5.scale(from: 0.0...1.0, to: 0.0...100.0), 50.0, accuracy: epsilon)

        XCTAssertEqualWithAccuracy(10.0.scale(from: 0.0...1.0, to: 0.0...10.0, clamp: false), 100.0, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(10.0.scale(from: 0.0...1.0, to: 0.0...10.0, clamp: true), 10.0, accuracy: epsilon)

        XCTAssertEqualWithAccuracy(0.25.scale(from: 0.0...1.0, to: -100.0...100.0), -50.0, accuracy: epsilon)

        // Difference between using and not using parentheses with negation.

        // remap(-10)
        XCTAssertEqualWithAccuracy((-10.0).scale(from: -50.0...0.0, to: 0.0...1.0), 0.8, accuracy: epsilon)

        // Negating remap(10)
        XCTAssertEqualWithAccuracy(-10.0.scale(from: -50.0...0.0, to: 0.0...1.0), -1.2, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(-10.0.scale(from: -50.0...0.0, to: 0.0...1.0, clamp: true), -1.0, accuracy: epsilon)
    }

    func testIntegerTypeRandom() {
        Int.testRandom()
        Int64.testRandom()
        Int32.testRandom()
        Int16.testRandom()
        Int8.testRandom()

        UInt.testRandom()
        UInt64.testRandom()
        UInt32.testRandom()
        UInt16.testRandom()
        UInt8.testRandom()
    }

}

private protocol EdgeCaseable {
    static var min: Self {get}
    static var max: Self {get}
}

extension Int: EdgeCaseable {}
extension Int64: EdgeCaseable {}
extension Int32: EdgeCaseable {}
extension Int16: EdgeCaseable {}
extension Int8: EdgeCaseable {}

extension UInt: EdgeCaseable {}
extension UInt64: EdgeCaseable {}
extension UInt32: EdgeCaseable {}
extension UInt16: EdgeCaseable {}
extension UInt8: EdgeCaseable {}

private extension UnsignedIntegerType where Self: EdgeCaseable {

    static func testRandom() {
        for _ in 0...10000 {
            Self.testRandomBoundaries(0, max: 0)
            Self.testRandomBoundaries(0, max: 1)
            Self.testRandomBoundaries(0, max: 13)

            Self.testRandomBoundaries(Self.min, max: Self.max)
        }
    }

    static func testRandomBoundaries(min: Self, max: Self) {
        let randomInt = Self.random(min, max: max)
        XCTAssertLessThanOrEqual(randomInt, max)
        XCTAssertGreaterThanOrEqual(randomInt, min)
    }

}

private extension SignedIntegerType where Self: EdgeCaseable {

    static func testRandom() {
        for _ in 0...10000 {
            Self.testRandomBoundaries(0, max: 0)
            Self.testRandomBoundaries(0, max: 1)
            Self.testRandomBoundaries(0, max: 13)

            Self.testRandomBoundaries(-1, max: 0)
            Self.testRandomBoundaries(-13, max: 0)
            Self.testRandomBoundaries(-13, max: 13)

            Self.testRandomBoundaries(Self.min, max: Self.max)
        }
    }

    static func testRandomBoundaries(min: Self, max: Self) {
        let randomInt = Self.random(min, max: max)
        XCTAssertLessThanOrEqual(randomInt, max)
        XCTAssertGreaterThanOrEqual(randomInt, min)
    }
}
