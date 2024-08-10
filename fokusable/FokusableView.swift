import ComposableArchitecture
import SwiftUI

struct FokusableView: View {
  @Bindable var store: StoreOf<FokusableFeature>
  @State var editingText = "" // 編集中のテキスト
  @FocusState var focus: Bool? // 編集中のTextFieldにフォーカスを与えるために使用する値
  
  var body: some View {
    NavigationSplitView {
      Group {
        switch store.dayState {
        case .empty:
          EmptyView()
        case .list(let days):
          DayListView(
            days: days,
            onDayTapped: { dayItem in
              store.send(.onSelectedDay(dayItem))
            }
          )
        case .error:
          ErrorView()
        }
      }
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

#Preview {
  FokusableView(
    store: Store(
      initialState: FokusableFeature.State()
    ) {
      FokusableFeature()
    }
  )
}
