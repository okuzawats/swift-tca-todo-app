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
    case onDaysFetched([Day])
  }

  @Dependency(\.dayRepository)
  var dayRepository: DayRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onEnter:
        logger.info("onEnter")
        return .run { send in
          let date = Date()
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          let _ = await dayRepository.save(Day(id: UUID(), date: formatter.string(from: date)))

          let allDays = await dayRepository.fetchAll()
          switch allDays {
          case .success(let days):
            await send(.onDaysFetched(days))
          case .failure(let error):
            logger.error("DayRepository#fetchAll failed with \(error)")
          }
        }
      case .onDaysFetched(let days):
        state.days = IdentifiedArrayOf(
          uniqueElements: days.map { day in
            DayItem(id: day.id, day: day.date)
          }
        )
        return .none
      }
    }
  }

  private let logger = Logger(label: "DayFeature")
}
