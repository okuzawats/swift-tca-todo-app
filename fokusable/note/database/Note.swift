import Foundation
import SwiftData

@Model
final class Note {
  init(id: UUID, text: String) {
    self.id = id
    self.text = text
  }

  @Attribute(.unique)
  let id: UUID

  let text: String
}
