import Foundation

struct NoteItem: Equatable, Identifiable {
  let id: UUID
  let isDone: Bool
  let text: String
  let isEdit: Bool
}
