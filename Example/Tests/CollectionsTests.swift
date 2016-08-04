import XCTest
import Swiftilities

class CollectionsTests: XCTestCase {

    func testRandomCollectionElement() {
        let array = Array<Int>(count: 142, repeatedValue: 1)

        for _ in 0...1000 {
            let _ = array.randomElement()
        }
    }

}
