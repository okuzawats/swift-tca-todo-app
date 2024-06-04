import ComposableArchitecture
import SwiftData
import SwiftUI

@main
struct FokusableApp: App {
  static let store = Store(
    initialState: FokusableFeature.State()
  ) {
    FokusableFeature()
      ._printChanges()
  }

  var body: some Scene {
    WindowGroup {
      FokusableView(
        store: FokusableApp.store
      )
      .modelContainer(for: [Day.self, Note.self])
    }
  }
}
