import Foundation
import SwiftData

@Model
final class Note {
  init(id: UUID, bracket: String, text: String) {
    self.id = id
    self.bracket = bracket
    self.text = text
  }
  
  @Attribute(.unique)
  let id: UUID
  let bracket: String
  let text: String
}
