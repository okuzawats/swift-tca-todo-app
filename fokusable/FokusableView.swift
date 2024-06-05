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
        ForEach(store.items) { item in
          Text(item.toPresentation())
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
