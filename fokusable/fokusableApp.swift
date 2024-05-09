import ComposableArchitecture
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
    }
  }
}
