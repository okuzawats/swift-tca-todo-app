import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct FokusableApp: App {
  static let store = Store(
    initialState: FokusableFeature.State()
  ) {
    FokusableFeature()
    // Stateの変化をログ出力してくれるTCAの機能を有効化する処理
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      FokusableView(
        store: FokusableApp.store
      )
      // SwiftDataのデータモデルの登録処理
      .modelContainer(for: [Day.self, Note.self])
    }
  }
}
