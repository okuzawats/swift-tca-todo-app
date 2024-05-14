import ComposableArchitecture
import SwiftUI

struct NoteView: View {
  @Bindable
  var store: StoreOf<NoteFeature>
  
  var body: some View {
    List {
      ForEach(store.items) { item in
        Text("- [\(item.bracket)] \(item.text)")
          .padding(.bottom, 4)
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .onAppear {
        store.send(.onEntered(UUID())) // TODO fix UUID
      }
  }
}

#Preview {
  NoteView(
    store: Store<NoteFeature.State, NoteFeature.Action>(
      initialState: NoteFeature.State(
        items: []
      )
    ) {
      NoteFeature()
    }
  )
}
