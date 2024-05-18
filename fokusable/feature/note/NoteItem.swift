import Foundation

struct NoteItem: Equatable, Identifiable {
  let id: UUID
  let bracket: String // TODO define enum
  let text: String
}
