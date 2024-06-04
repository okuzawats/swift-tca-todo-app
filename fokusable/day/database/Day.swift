import Foundation
import SwiftData

@Model
final class Day {
  init(id: UUID, date: String) {
    self.id = id
    self.date = date
  }

  @Attribute(.unique)
  let id: UUID

  /// a string that represent date.
  /// string format must be `2024-05-19`.
  @Attribute(.unique)
  let date: String
}
