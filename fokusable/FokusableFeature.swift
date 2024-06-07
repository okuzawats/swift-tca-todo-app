import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct FokusableFeature {
  @ObservableState
  struct State: Equatable {
    var days: IdentifiedArrayOf<DayItem> = []
    var daysError: String? = nil
    var notes: IdentifiedArrayOf<NoteItem> = []
    var notesError: String? = nil
  }
  
  enum Action {
    case onEnter
    case onFetchedDays(IdentifiedArrayOf<DayItem>)
    case onErroredFetchingDays(Error)
    case onSelectedDay(DayItem)
    case onFetchedNote(IdentifiedArrayOf<NoteItem>)
    case onErroredFetchingNote(Error)
  }
  
  @Dependency(\.dayFetchingService) var dayFetchingService: DayFetchingService
  
  @Dependency(\.noteFetchingService) var noteFetchingService: NoteFetchingService
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .onEnter:
        return .run { send in
          switch await dayFetchingService.fetchAll() {
          case .success(let days):
            await send(.onFetchedDays(days))
          case .failure(let error):
            await send(.onErroredFetchingDays(error))
          }
        }
        
      case .onFetchedDays(let days):
        state.days = days
        state.daysError = nil
        return .none
        
      case .onErroredFetchingDays(let error):
        logger.error("fetching days failed with \(error)")
        state.daysError = "Oops! Something happend."
        return .none
        
      case .onSelectedDay(let day):
        return .run { send in
          switch await noteFetchingService.fetchById(day.id) {
          case .success(let notes):
            await send(.onFetchedNote(notes))
          case .failure(let error):
            await send(.onErroredFetchingNote(error))
          }
        }
        
      case .onFetchedNote(let notes):
        state.notes = notes
        state.notesError = nil
        return .none
        
      case .onErroredFetchingNote(let error):
        logger.error("fetching notes failed with \(error)")
        state.notesError = "Oops! Something happend."
        return .none
      }
    }
  }
  
  private let logger = Logger(label: "FokusableFeature")
}
