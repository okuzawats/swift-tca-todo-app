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
    case onFetchedDays(IdentifiedArrayOf<DayItem>)
    case onSelectedDay(DayItem)
  }

  @Dependency(\.dayFetchingService) var dayFetchingService

  @Dependency(\.noteRepository) var noteRepository: NoteRepository
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .onEnter:
        return .run { send in
          let allDays = await dayFetchingService.invoke()
          switch allDays {
          case .success(var days):
            await send(.onFetchedDays(days))
          case .failure(let error):
            logger.error("fetching a list of day failed with \(error)")
          }
        }
        
      case .onFetchedDays(let days):
        state.days = days
        return .none
        
      case .onSelectedDay(let day):
        state.items = [
          NoteItem(id: UUID(), bracket: "X", text: "Done!"),
          NoteItem(id: UUID(), bracket: ">", text: "Postponed"),
          NoteItem(id: UUID(), bracket: "  ", text: "\(day.id)"),
        ]
        return .none
      }
    }
  }
  
  private let logger = Logger(label: "FokusableFeature")
}
