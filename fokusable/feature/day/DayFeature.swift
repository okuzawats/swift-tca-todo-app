import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct DayFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var selectedItem: NoteFeature.State?
    var days: IdentifiedArrayOf<DayItem> = []
  }
  
  enum Action {
    case onEnter
    case onDaySelected(UUID)
    case onDaysFetched([Day])
    case navigateToSelectedDay(PresentationAction<NoteFeature.Action>)
  }

  @Dependency(\.dayRepository)
  var dayRepository: DayRepository

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
            await send(.onDaysFetched(days))
          case .failure(let error):
            logger.error("DayRepository#fetchAll failed with \(error)")
          }
        }
      case let .onDaySelected(id):
        return .run { send in
          await send(.navigateToSelectedDay(.presented(.onEntered(id))))
        }
      case .onDaysFetched(let days):
        state.days = IdentifiedArrayOf(
          uniqueElements: days.map { day in
            DayItem(id: day.id, day: day.date)
          }
        )
        return .none
      case let .navigateToSelectedDay(.presented(.onEntered(id))):
        return .none
      case .navigateToSelectedDay(.presented(.onSaveButtonTapped)):
        return .none
      case .navigateToSelectedDay(.presented(.onSuccessfullySaved)):
        return .none
      case .navigateToSelectedDay(.dismiss):
        return .none
      }
    }
    .ifLet(\.$selectedItem, action: \.navigateToSelectedDay) {
      NoteFeature()
    }
  }

  private let logger = Logger(label: "DayFeature")
}
