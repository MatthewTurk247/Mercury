import XCTest
@testable import Mercury

final class MercuryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Mercury().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
