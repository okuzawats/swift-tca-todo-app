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
  
  @Dependency(\.dayRepository) var dayRepository: DayRepository
  
  @Dependency(\.dayMapper) var dayMapper: DayMapper
  
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
            await send(
              .onFetchedDays(
                dayMapper.toPresentation(days)
              )
            )
          case .failure(let error):
            logger.error("DayRepository#fetchAll failed with \(error)")
          }
        }
        
      case let .onFetchedDays(days):
        state.days = days
        return .none
        
      case let .onSelectedDay(day):
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
