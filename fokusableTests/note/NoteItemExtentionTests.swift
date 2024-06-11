import Foundation
import XCTest

final class NoteItemExtentionTests: XCTestCase {
  func testToPresentation() throws {
    let noteItem = NoteItem(id: UUID(), bracket: "X", text: "buy me a coffee!")

    let actual = noteItem.toPresentation()
    XCTAssertEqual(actual, "- [X] buy me a coffee!")
  }
}
