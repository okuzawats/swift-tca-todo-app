import ComposableArchitecture
import Foundation
import Logging

struct NoteState: Equatable {
  var text: String = ""
}

@Reducer
struct NoteFeature {

  private let logger = Logger(label: "NoteFeature")

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
        logger.info("onEntered with UUID \(uuid)")
        return .none
      case .onSaveButtonTapped:
        return .run { send in
          _ = await noteRepository.save(42)
          await send(.onSuccessfullySaved)
        }
      case .onSuccessfullySaved:
        return .none
      }
    }
  }
}