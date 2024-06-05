import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct FokusableFeature {
  @ObservableState
  struct State: Equatable {
    var days: IdentifiedArrayOf<DayItem> = []
    var items: IdentifiedArrayOf<NoteItem> = []
  }

  enum Action {
    case onEnter
    case onFetchedDays([Day])
    case onDaySelected
  }

  @Dependency(\.dayRepository) var dayRepository: DayRepository

  @Dependency(\.noteRepository) var noteRepository: NoteRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .onEnter:
        return .run { send in
          let allDays = await dayRepository.fetchAll()
          switch allDays {
          case .success(var days):
            let dateOfToday = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            let hasCreatedToday = days.contains(where: { day in
              day.date == formatter.string(from: dateOfToday)
            })
            if !hasCreatedToday {
              let today = Day(
                id: UUID(),
                date: formatter.string(from: dateOfToday)
              )
              let _ = await dayRepository.save(today)
              days.insert(today, at: 0)
            }
            await send(.onFetchedDays(days))
          case .failure(let error):
            logger.error("DayRepository#fetchAll failed with \(error)")
          }
        }

      case let .onFetchedDays(days):
        state.days = IdentifiedArrayOf(
          uniqueElements: days.map { day in
            DayItem(id: day.id, day: day.date)
          }
        )
        return .none

      case .onDaySelected:
        return .none
      }
    }
  }

  private let logger = Logger(label: "FokusableFeature")
}
