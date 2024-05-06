import ComposableArchitecture
import Foundation

struct Foo: Equatable, Identifiable {
  let id: UUID
  var answer: Int
}

@Reducer
struct NoteFeature {
  @ObservableState
  struct State: Equatable {
    var answers: IdentifiedArrayOf<Foo> = []
    var text: String? = nil
  }
  
  enum Action {
    case onSomethingTapped
    case onFoo(String)
  }

  @Dependency(\.noteRepository)
  var noteRepository: NoteRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onSomethingTapped:
        return .run { send in
          let retVal = try await noteRepository.save(42)
          await send(.onFoo(retVal))
        }
      case let .onFoo(text):
        state.text = text
        return .none
      }
    }
  }
}
