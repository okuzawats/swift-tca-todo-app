import ComposableArchitecture

@Reducer
struct AppFeature {
  struct State: Equatable {
    var day: DayFeature.State = DayFeature.State()
    var note: NoteFeature.State = NoteFeature.State()
  }
  
  enum Action {
    case day(DayFeature.Action)
    case note(NoteFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.day, action: \.day) {
      DayFeature()
    }

    Scope(state: \.note, action: \.note) {
      NoteFeature()
    }

    Reduce { state, action in
      return .none
    }
  }
}
