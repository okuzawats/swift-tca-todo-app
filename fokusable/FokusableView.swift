import ComposableArchitecture
import SwiftUI

struct FokusableView: View {
  @Bindable var store: StoreOf<FokusableFeature>
  
  // TODO: integrate to store
  @State var text = ""
  
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
          Text("Oops! Something happend.")
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
                Text("-")
                Text("[\(note.bracket)]")
                  .onTapGesture {
                    store.send(.onCheckNote(note.id))
                  }
                if (note.isEdit) {
                  TextField(
                    "Enter text",
                    text: $text
                  )
                  .textFieldStyle(DefaultTextFieldStyle())
                  .onSubmit {
                    store.send(.onSaveNote(note.id, text))
                    // reset text after saved
                    text = ""
                  }
                } else {
                  Text("\(note.text)")
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                  // need this line to activate tap gesture
                    .background(.white)
                    .onTapGesture {
                      store.send(.onEditNote(note.id))
                    }
                }
              }
              .padding(.bottom, 4)
            }
          }
          
        case .error:
          Text("Oops! Something happend.")
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
