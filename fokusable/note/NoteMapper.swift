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
          let isDone = line.status == "X"
          return NoteItem(id: line.id, isDone: isDone, text: line.text, isEdit: false)
        }
      return IdentifiedArrayOf(uniqueElements: elements)
    },
    ToData: { noteItem in
      let status = if noteItem.isDone { "x" } else { "" }
      return Note(id: noteItem.id, status: status, text: noteItem.text)
    }
  )
}

extension DependencyValues {
  var noteMapper: NoteMapper {
    get { self[NoteMapper.self] }
    set { self[NoteMapper.self] = newValue }
  }
}
