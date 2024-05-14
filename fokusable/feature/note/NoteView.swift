import ComposableArchitecture
import SwiftUI

struct NoteView: View {
  @Bindable
  var store: StoreOf<NoteFeature>

  var body: some View {
    Text("This is NoteView.")
      .onAppear {
        store.send(.onEntered(UUID())) // TODO fix UUID
      }
  }
}

#Preview {
  NoteView(
    store: Store<NoteFeature.State, NoteFeature.Action>(
      initialState: NoteFeature.State(
        noteState: NoteState(text: "Hello World!")
      )
    ) {
      NoteFeature()
    }
  )
}
