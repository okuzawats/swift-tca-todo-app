import ComposableArchitecture
import Foundation
import Logging

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
        logger.info("onEnter")
        return .none
      }
    }
  }

  private let logger = Logger(label: "DayFeature")
}
