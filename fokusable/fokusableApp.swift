import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct fokusableApp: App {
  static let store = Store(
    initialState: AppFeature.State()
  ) {
    AppFeature()
  }

  var body: some Scene {
    WindowGroup {
      AppView(
        store: fokusableApp.store
      )
      .modelContainer(for: [Day.self, Note.self])
    }
  }
}
