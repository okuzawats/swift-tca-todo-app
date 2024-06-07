import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct FokusableFeature {
  @ObservableState
  struct State: Equatable {
    var days: IdentifiedArrayOf<DayItem> = []
    var items: IdentifiedArrayOf<NoteItem> = []
    var errorMessage: String? = nil
  }
  
  enum Action {
    case onEnter
    case onFetchedDays(IdentifiedArrayOf<DayItem>)
    case onFetchError(Error)
    case onSelectedDay(DayItem)
  }
  
  @Dependency(\.dayFetchingService) var dayFetchingService
  
  @Dependency(\.noteRepository) var noteRepository: NoteRepository
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .onEnter:
        return .run { send in
          switch await dayFetchingService.fetchAll() {
          case .success(let days):
            await send(.onFetchedDays(days))
          case .failure(let error):
            await send(.onFetchError(error))
          }
        }
        
      case .onFetchedDays(let days):
        state.days = days
        state.errorMessage = nil
        return .none
        
      case .onFetchError(let error):
        logger.error("fetching a list of day failed with \(error)")
        state.errorMessage = "Oops! Something happend."
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
