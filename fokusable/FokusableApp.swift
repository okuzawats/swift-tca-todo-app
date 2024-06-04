import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct FokusableApp: App {
  static let store = Store(
    initialState: AppFeature.State()
  ) {
    AppFeature()
      ._printChanges()
  }

  var body: some Scene {
    WindowGroup {
      AppView(
        store: FokusableApp.store
      )
      .modelContainer(for: [Day.self, Note.self])
    }
  }
}
