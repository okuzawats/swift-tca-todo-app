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
        // TODO
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        state.days = [
          DayItem(id: UUID(), day: formatter.string(from: date))
        ]
        logger.info("onEnter with date \(formatter.string(from: date))")
        return .none
      }
    }
  }

  private let logger = Logger(label: "DayFeature")
}
