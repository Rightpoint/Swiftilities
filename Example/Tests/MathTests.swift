import Swiftilities
import XCTest

class MathTests: XCTestCase {

    let epsilon = 0.00001

    func testFloatingPointScale() {
        XCTAssertEqual(1.0.scaled(from: 0.0...1.0, to: 0.0...1.0), 1.0, accuracy: epsilon)
        XCTAssertEqual(0.5.scaled(from: 0.0...1.0, to: 0.0...100.0), 50.0, accuracy: epsilon)

        XCTAssertEqual(10.0.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: false), 100.0, accuracy: epsilon)
        XCTAssertEqual(10.0.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: true), 10.0, accuracy: epsilon)
        XCTAssertEqual(10.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: false), 100.0, accuracy: epsilon)

        XCTAssertEqual(0.25.scaled(from: 0.0...1.0, to: -100.0...100.0), -50.0, accuracy: epsilon)

        // Difference between using and not using parentheses with negation.

        // remap(-10)
        XCTAssertEqual((-10.0).scaled(from: -50.0...0.0, to: 0.0...1.0), 0.8, accuracy: epsilon)

        // Negating remap(10)
        XCTAssertEqual(-10.0.scaled(from: -50.0...0.0, to: 0.0...1.0), -1.2, accuracy: epsilon)
        XCTAssertEqual(-10.0.scaled(from: -50.0...0.0, to: 0.0...1.0, clamped: true), -1.0, accuracy: epsilon)
    }

    func testFloatingPointReverseScale() {
        XCTAssertEqual(1.0.scaled(from: 0.0...1.0, to: 0.0...1.0, reversed: true), 0.0, accuracy: epsilon)
        XCTAssertEqual(0.5.scaled(from: 0.0...1.0, to: 0.0...100.0, reversed: true), 50.0, accuracy: epsilon)

        XCTAssertEqual(10.0.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: false, reversed: true), -90.0, accuracy: epsilon)
        XCTAssertEqual(10.0.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: true, reversed: true), 0.0, accuracy: epsilon)
        XCTAssertEqual(10.scaled(from: 0.0...1.0, to: 0.0...10.0, clamped: false, reversed: true), -90.0, accuracy: epsilon)

        XCTAssertEqual(0.25.scaled(from: 0.0...1.0, to: -100.0...100.0, reversed: true), 50.0, accuracy: epsilon)

        XCTAssertEqual(0.25.scaled(from: 0.0...1.0, to: 0.0...1.0, reversed: true), 0.75, accuracy: epsilon)

        // Difference between using and not using parentheses with negation.

        // remap(-10)
        XCTAssertEqual((-10.0).scaled(from: -50.0...0.0, to: 0.0...1.0, reversed: true), 0.2, accuracy: epsilon)

        // Negating remap(10)
        XCTAssertEqual(-10.0.scaled(from: -50.0...0.0, to: 0.0...1.0, reversed: true), 0.2, accuracy: epsilon)
        XCTAssertEqual(-10.0.scaled(from: -50.0...0.0, to: 0.0...1.0, clamped: true, reversed: true), 0.0, accuracy: epsilon)
    }

    func testClamping() {
        XCTAssertEqual(0.clamped(to: -10...20), 0)
        XCTAssertEqual((-10).clamped(to: -10...20), -10)
        XCTAssertEqual(UInt(0).clamped(to: 10...20), 10)
        XCTAssertEqual(Double.pi.clamped(to: 0...1), 1, accuracy: epsilon)
        XCTAssertEqual(Double.pi.clamped(to: 3...4), Double.pi, accuracy: epsilon)
        XCTAssertEqual(-20.clamped(to: 0...1), -1, accuracy: epsilon)
        XCTAssertEqual((-20).clamped(to: 0...1), 0, accuracy: epsilon)
    }

}
