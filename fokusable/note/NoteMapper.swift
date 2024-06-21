import ComposableArchitecture
import Dependencies

struct NoteMapper {
  var toPresentation: ([Note]) -> IdentifiedArrayOf<NoteItem>
  var ToData: ((NoteItem) -> Note)
}

extension NoteMapper: DependencyKey {
  static let liveValue: NoteMapper = Self(
    toPresentation: { note in
      let elements = note
        .map { line in
          NoteItem(id: line.id, bracket: line.bracket, text: line.text, isEdit: false)
        }
      return IdentifiedArrayOf(uniqueElements: elements)
    },
    ToData: { noteItem in
      return Note(id: noteItem.id, bracket: noteItem.bracket, text: noteItem.text)
    }
  )
}

extension DependencyValues {
  var noteMapper: NoteMapper {
    get { self[NoteMapper.self] }
    set { self[NoteMapper.self] = newValue }
  }
}
