import ComposableArchitecture
import Foundation
import Logging

@Reducer
struct FokusableFeature {
  enum DayState: Equatable {
    case empty
    case list(items: IdentifiedArrayOf<DayItem>)
    case error
  }

  @ObservableState
  struct State: Equatable {
    var dayState: DayState = .empty
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
        state.dayState = .list(items: days)
        return .run { send in
          switch await dayFetchingService.fetchToday() {
          case .success(let today):
            await send(.onSelectedDay(today))
          case .failure(let error):
            await send(.onErroredFetchingNote(error))
          }
        }
        
      case .onErroredFetchingDays(let error):
        logger.error("fetching days failed with \(error)")
        state.dayState = .error
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
