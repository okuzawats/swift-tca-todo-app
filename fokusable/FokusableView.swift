import ComposableArchitecture
import SwiftUI

struct FokusableView: View {
  @Bindable
  var store: StoreOf<FokusableFeature>
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(store.days) { item in
          Text("\(item.day)")
            .onTapGesture {
              store.send(.onSelectedDay(item))
            }
        }
      }
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    } detail: {
      List {
        ForEach(store.notes) { note in
          Text(note.toPresentation())
            .padding(.bottom, 4)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .onAppear {
        store.send(.onEnter)
      }
    }
  }
}

// TODO implement Preview
