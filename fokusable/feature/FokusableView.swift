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
      Group {
        switch store.noteState {
        case .empty:
          Text("") // ノートが空の場合にdetailのエリアが潰れないようにするための空のView
        case .list(let notes):
          NoteListView(
            notes: notes,
            onCheckBoxTapped: { noteItem in
              store.send(.onCheckNote(noteItem.id))
            },
            onSaveButtonTapped: { noteItem, text in
              store.send(.onSaveNote(noteItem.id, text))
            },
            onEditButtonTapped: { noteItem in
              store.send(.onEditNote(noteItem.id))
            }
          )
        case .error:
          ErrorView()
        }
      }
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
