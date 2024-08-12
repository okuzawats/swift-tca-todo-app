import Dependencies
import SwiftData

struct NoteDatabase {
  let context: ModelContext
}

extension NoteDatabase: DependencyKey {
  static let liveValue: NoteDatabase = Self(
    context: { ModelContext(FokusableApp.sharedModelContainer) }()
  )
}

extension DependencyValues {
  var noteDatabase: NoteDatabase {
    get { self[NoteDatabase.self] }
    set { self[NoteDatabase.self] = newValue }
  }
}
