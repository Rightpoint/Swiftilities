import XCTest
import Swiftilities

class Tests: XCTestCase {

    func testFloatingPointScale() {

        let epsilon = 0.00001

        XCTAssertEqualWithAccuracy(1.0.scale(from: 0.0...1.0, to: 0.0...1.0), 1.0, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(0.5.scale(from: 0.0...1.0, to: 0.0...100.0), 50.0, accuracy: epsilon)

        XCTAssertEqualWithAccuracy(10.0.scale(from: 0.0...1.0, to: 0.0...10.0, clamp: false), 100.0, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(10.0.scale(from: 0.0...1.0, to: 0.0...10.0, clamp: true), 10.0, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(10.scale(from: 0.0...1.0, to: 0.0...10.0, clamp: false), 100.0, accuracy: epsilon)

        XCTAssertEqualWithAccuracy(0.25.scale(from: 0.0...1.0, to: -100.0...100.0), -50.0, accuracy: epsilon)

        // Difference between using and not using parentheses with negation.

        // remap(-10)
        XCTAssertEqualWithAccuracy((-10.0).scale(from: -50.0...0.0, to: 0.0...1.0), 0.8, accuracy: epsilon)

        // Negating remap(10)
        XCTAssertEqualWithAccuracy(-10.0.scale(from: -50.0...0.0, to: 0.0...1.0), -1.2, accuracy: epsilon)
        XCTAssertEqualWithAccuracy(-10.0.scale(from: -50.0...0.0, to: 0.0...1.0, clamp: true), -1.0, accuracy: epsilon)
    }

}
