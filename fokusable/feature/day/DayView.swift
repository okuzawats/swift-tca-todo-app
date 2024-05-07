import ComposableArchitecture
import SwiftUI

struct DayView: View {
  @Bindable
  var store: StoreOf<DayFeature>

  var body: some View {
    List {
      ForEach(store.days) { item in
        Text("day = \(item.day)")
      }
    }
  }
}

#Preview {
  DayView(
    store: Store<DayFeature.State, DayFeature.Action>(
      initialState: DayFeature.State(
        days: [
          DayItem(id: UUID(), day: "2024-05-08"),
          DayItem(id: UUID(), day: "2024-05-09"),
          DayItem(id: UUID(), day: "2024-05-10"),
        ]
      )
    ) {
      DayFeature()
    }
  )
}
