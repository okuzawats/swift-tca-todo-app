import Dependencies
import SwiftData

struct NoteDatabase {
  let context: ModelContext
}

extension NoteDatabase: DependencyKey {
  static let liveValue: NoteDatabase = Self(
    context: { appContext }()
  )
}

extension DependencyValues {
  var noteDatabase: NoteDatabase {
    get { self[NoteDatabase.self] }
    set { self[NoteDatabase.self] = newValue }
  }
}

fileprivate let appContext: ModelContext = {
  ModelContext(FokusableApp.sharedModelContainer)
}()
