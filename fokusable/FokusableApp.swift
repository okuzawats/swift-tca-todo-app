import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct FokusableApp: App {
  static let store = Store(initialState: FokusableFeature.State()) {
    FokusableFeature()
      ._printChanges() // TCAのログ出力機能を有効化
  }
  
  var body: some Scene {
    WindowGroup {
      FokusableView(store: FokusableApp.store)
        .modelContainer(FokusableModelContainer.shared)
    }
  }
}
