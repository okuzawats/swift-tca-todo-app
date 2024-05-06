import ComposableArchitecture
import SwiftUI

struct NoteView: View {
  @Bindable
  var store: StoreOf<NoteFeature>

  var body: some View {
    Text("HELLO")
    List {
      ForEach(store.answers) { answer in
        Text("answer = \(answer.answer)")
      }
    }
  }
}

#Preview {
  NoteView(
    store: Store<NoteFeature.State, NoteFeature.Action>(
      initialState: NoteFeature.State(
        answers: [
          Foo(id: UUID(), answer: 1),
          Foo(id: UUID(), answer: 3),
          Foo(id: UUID(), answer: 5),
        ]
      )
    ) {
      NoteFeature()
    }
  )
}
