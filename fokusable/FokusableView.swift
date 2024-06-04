import ComposableArchitecture
import SwiftUI

struct FokusableView: View {
  @Bindable
  var store: StoreOf<FokusableFeature>

  var body: some View {
    NavigationSplitView {
      DayView(
        store: store.scope(state: \.day, action: \.day)
      )
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    } detail: {
      NoteView(
        store: store.scope(state: \.note, action: \.note)
      )
    }
  }
}
