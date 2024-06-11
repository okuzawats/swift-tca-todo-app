import XCTest

final class DayItemTests: XCTestCase {
  func testTheFirstDay() throws {
    let dayItem = DayItem(id: UUID(), day: "0000-01-01")
    XCTAssertEqual(dayItem.day, "0000-01-01")
  }
  
  func testTheLastDay() throws {
    let dayItem = DayItem(id: UUID(), day: "9999-12-31")
    XCTAssertEqual(dayItem.day, "9999-12-31")
  }
}
