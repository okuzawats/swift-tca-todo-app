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
        case .list(let items):
          List {
            ForEach(items) { item in
              Text("\(item.day)")
                .onTapGesture {
                  store.send(.onSelectedDay(item))
                }
            }
          }
        case .error:
          ErrorView()
        }
      }
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    } detail: {
      Group {
        switch store.noteState {
        case .empty:
          // need this line to display overall view
          Text("")
          
        case .list(let notes):
          List {
            ForEach(notes) { note in
              HStack {
                CheckBox(isChecked: note.isDone)
                  .onTapGesture {
                    store.send(.onCheckNote(note.id))
                  }
                
                if (note.isEdit) {
                  TextField(
                    "Enter text",
                    text: $editingText
                  )
                  .textFieldStyle(DefaultTextFieldStyle())
                  .focused($focus, equals: true)
                  .onSubmit {
                    store.send(.onSaveNote(note.id, editingText))
                    // reset text after saved
                    editingText = ""
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
                    .background(.white) // need this line to activate tap gesture
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
