import ComposableArchitecture
import Foundation

struct DayItem: Equatable, Identifiable {
  let id: UUID
  let day: String
}

@Reducer
struct DayFeature {
  @ObservableState
  struct State: Equatable {
    var days: IdentifiedArrayOf<DayItem> = []
  }
  
  enum Action {
    case onEnter
  }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onEnter:
        return .none
      }
    }
  }
}
