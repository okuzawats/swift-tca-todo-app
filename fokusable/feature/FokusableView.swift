import ComposableArchitecture
import SwiftUI

/// アプリケーション全体のルートとなるView
///
/// - Parameters:
///   - store: Composable ArchitectureにおけるStore。ルートのFeatureであるFokusableFeatureを型引数として持つ。
struct FokusableView: View {
  @Bindable var store: StoreOf<FokusableFeature>
  
  var body: some View {
    NavigationSplitView {
      DayPageView(
        state: store.dayState,
        onDayTapped: { store.send(.onSelectedDay($0)) }
      )
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    } detail: {
      NotePageView(
        state: store.noteState,
        onCheckBoxTapped: { store.send(.onCheckNote($0.id)) },
        onSaveButtonTapped: { store.send(.onSaveNote($0.id, $1)) },
        onEditButtonTapped: { store.send(.onEditNote($0.id)) }
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .onAppear {
        store.send(.onEnter)
      }
    }
  }
}

//#Preview {
//  FokusableView(
//    store: Store(
//      initialState: FokusableFeature.State()
//    ) {
//      FokusableFeature()
//    }
//  )
//}
