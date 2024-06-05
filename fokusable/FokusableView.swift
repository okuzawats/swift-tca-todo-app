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
              store.send(.onDaySelected(item))
            }
        }
      }.onAppear {
        store.send(.onEnter)
      }
      .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    } detail: {
      List {
        //        ForEach(store.items) { item in
        //          Text(item.toPresentation())
        //            .padding(.bottom, 4)
        //        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .onAppear {
        //        store.send(.onEntered(UUID())) // TODO fix UUID
      }
    }
  }
}

// TODO implement Preview
