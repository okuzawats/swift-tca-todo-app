import ComposableArchitecture
import SwiftUI

@main
struct fokusableApp: App {
  static let store = Store(initialState: NoteFeature.State()) {
    NoteFeature()
  }

  var body: some Scene {
    WindowGroup {
      NoteView(
        store: fokusableApp.store
      )
    }
  }
}
