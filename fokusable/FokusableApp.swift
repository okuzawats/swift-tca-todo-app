import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct FokusableApp: App {
  static var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Day.self,
      Note.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
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
      .modelContainer(FokusableApp.sharedModelContainer)
    }
  }
}
