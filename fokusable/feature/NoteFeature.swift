import ComposableArchitecture
import Foundation

struct Foo: Equatable, Identifiable {
  let id: UUID
  var answer: Int
}

struct NoteState: Equatable {
  var text: String = ""
}

@Reducer
struct NoteFeature {
  @ObservableState
  struct State: Equatable {
    var noteState: NoteState
  }
  
  enum Action {
    /// when `NoteView` is entered.
    case onEntered    /// when save button tapped to save the note.
    case onSaveButtonTapped
    /// when the note is successfully saved.
    case onSuccessfullySaved
  }

  @Dependency(\.noteRepository)
  var noteRepository: NoteRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onEntered:
        return .none
      case .onSaveButtonTapped:
        return .run { send in
          let retVal = try await noteRepository.save(42)
          await send(.onSuccessfullySaved)
        }
      case .onSuccessfullySaved:
        return .none
      }
    }
  }
}