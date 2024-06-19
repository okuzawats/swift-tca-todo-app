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
  
  enum NoteState: Equatable {
    case empty
    case list(items: IdentifiedArrayOf<NoteItem>)
    case error
  }
  
  @ObservableState
  struct State: Equatable {
    var dayState: DayState = .empty
    var noteState: NoteState = .empty
  }
  
  enum Action {
    case onEnter
    case onFetchedDays(IdentifiedArrayOf<DayItem>)
    case onErroredFetchingDays(Error)
    case onSelectedDay(DayItem)
    case onFetchedNote(IdentifiedArrayOf<NoteItem>)
    case onErroredFetchingNote(Error)
    case onEditNote(UUID)
    case onCheckNote(UUID)
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
        state.noteState = .empty
        return .run { send in
          switch await noteFetchingService.fetchById(day.id) {
          case .success(var notes):
            // add empty note to show input field
            let emptyNote = NoteItem(id: UUID(), bracket: " ", text: "", isEdit: false)
            notes.append(emptyNote)
            await send(.onFetchedNote(notes))
          case .failure(let error):
            await send(.onErroredFetchingNote(error))
          }
        }
        
      case .onFetchedNote(let notes):
        state.noteState = .list(items: notes)
        return .none
        
      case .onErroredFetchingNote(let error):
        logger.error("fetching notes failed with \(error)")
        state.noteState = .error
        return .none
        
      case .onEditNote(let id):
        switch state.noteState {
        case .list(let noteItems):
          state.noteState = .list(
            items: IdentifiedArrayOf(
              uniqueElements: noteItems
                .map { noteItem in
                  // filter note not changed
                  if noteItem.id != id {
                    return noteItem
                  }
                  
                  return NoteItem(id: noteItem.id, bracket: noteItem.bracket, text: noteItem.text, isEdit: true)
                }
            )
          )
        default:
          logger.info("illegal state, note should be a list")
        }
        return .none
        
      case .onCheckNote(let id):
        switch state.noteState {
        case .list(let noteItems):
          state.noteState = .list(
            items: IdentifiedArrayOf(
              uniqueElements: noteItems
                .map { noteItem in
                  // filter note not changed
                  if noteItem.id != id {
                    return noteItem
                  }
                  
                  let bracket = noteItem.bracket == " " ? "X" : " "
                  return NoteItem(id: noteItem.id, bracket: bracket, text: noteItem.text, isEdit: false)
                }
            )
          )
        default:
          logger.info("illegal state, note should be a list")
        }
        return .none
      }
    }
  }
  
  private let logger = Logger(label: "FokusableFeature")
}
