import Dependencies
import SwiftData

struct NoteDatabase {
  var context: () throws -> ModelContext
}

extension NoteDatabase: DependencyKey {
  static let liveValue: NoteDatabase = Self(
    context: { appContext }
  )
}

extension DependencyValues {
  var noteDatabase: NoteDatabase {
    get { self[NoteDatabase.self] }
    set { self[NoteDatabase.self] = newValue }
  }
}

fileprivate let appContext: ModelContext = {
  do {
    let container = try ModelContainer(for: Note.self)
    return ModelContext(container)
  } catch {
    fatalError("Failed to create container.")
  }
}()
