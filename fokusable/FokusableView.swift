import ComposableArchitecture
import SwiftUI

struct FokusableView: View {
  @Bindable var store: StoreOf<FokusableFeature>
  
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
          // FIXME: if use EmptyView, the overall View draw nothing.
          Text("")
        case .list(let notes):
          List {
            ForEach(notes) { note in
              Text(note.toPresentation())
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
