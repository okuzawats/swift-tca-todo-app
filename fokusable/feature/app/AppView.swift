import ComposableArchitecture
import SwiftUI

struct AppView: View {
  @Bindable
  var store: StoreOf<AppFeature>

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
