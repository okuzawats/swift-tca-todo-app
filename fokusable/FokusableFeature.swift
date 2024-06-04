import ComposableArchitecture
import Logging

@Reducer
struct FokusableFeature {
  struct State: Equatable {
    var days: IdentifiedArrayOf<DayItem> = []
    var items: IdentifiedArrayOf<NoteItem> = []
  }
  
  enum Action {
    case onAppear
    case onDaySelected
  }
  
  @Dependency(\.dayRepository) var dayRepository: DayRepository

  @Dependency(\.noteRepository) var noteRepository: NoteRepository

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      logger.info("\(action)") // FIXME
      return .none
    }
  }
  
  private let logger = Logger(label: "FokusableFeature")
}
