import ComposableArchitecture
import Dependencies

struct NoteMapper {
  var toPresentation: ([Note]) -> IdentifiedArrayOf<NoteItem>
}

extension NoteMapper: DependencyKey {
  static let liveValue: NoteMapper = Self(
    toPresentation: { note in
      let elements = note
        .map { line in
          NoteItem(id: line.id, bracket: "x", text: line.text, isEdit: false)
        }
      return IdentifiedArrayOf(uniqueElements: elements)
    }
  )
}

extension DependencyValues {
  var noteMapper: NoteMapper {
    get { self[NoteMapper.self] }
    set { self[NoteMapper.self] = newValue }
  }
}
