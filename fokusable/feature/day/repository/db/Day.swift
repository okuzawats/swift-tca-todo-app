import Foundation
import SwiftData

@Model
final class Day {
  init(id: UUID) {
    self.id = id
  }

  @Attribute(.unique)
  let id: UUID
}
