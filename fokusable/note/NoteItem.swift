import Foundation

struct NoteItem: Equatable, Identifiable {
  let id: UUID
  let isChecked: Bool
  let bracket: String // TODO: define enum
  let text: String
  let isEdit: Bool
}
