import ComposableArchitecture
import Foundation

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
    case onEntered(UUID)
    case onSaveButtonTapped
    case onSuccessfullySaved
  }

  @Dependency(\.noteRepository)
  var noteRepository: NoteRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .onEntered(uuid):
        // TODO
        print(uuid)
        return .none
      case .onSaveButtonTapped:
        return .run { send in
          _ = try await noteRepository.save(42)
          await send(.onSuccessfullySaved)
        }
      case .onSuccessfullySaved:
        return .none
      }
    }
  }
}
