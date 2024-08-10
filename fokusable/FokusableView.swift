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
          List {
            ForEach(notes) { note in
              HStack {
                CheckBox(isChecked: note.isDone)
                  .onTapGesture {
                    store.send(.onCheckNote(note.id))
                  }
                
                if (note.isEdit) {
                  TextField("Enter Your TODO here.", text: $editingText)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .focused($focus, equals: true)
                    .onSubmit {
                      store.send(.onSaveNote(note.id, editingText))
                      editingText = "" // 保存した時、テキストを空にする
                    }
                    .onAppear {
                      editingText = note.text
                      focus = true
                    }
                    .onDisappear {
                      focus = nil
                    }
                } else {
                  Text("\(note.text)")
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white) // タップを有効化するために必要
                    .onTapGesture {
                      store.send(.onEditNote(note.id))
                    }
                }
              }
              .listRowSeparator(.hidden)
              .padding(.bottom, 4)
            }
          }
          
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
