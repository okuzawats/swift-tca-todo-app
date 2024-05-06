import Foundation
import SwiftData

@Model
final class Note {
  init(id: UUID) {
    self.id = id
  }

  @Attribute(.unique)
  let id: UUID
}
