import Dependencies
import Foundation
import SwiftData

struct NoteRepository {
  var save: (Int) async throws -> String
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    save: { _ in
      @Dependency(\.noteDatabase.context) var context
      let noteContext = try context()
      noteContext.insert(Note(id: UUID()))
      try noteContext.save()
      return "foo"
    }
  )
}

extension DependencyValues {
  var noteRepository: NoteRepository {
    get { self[NoteRepository.self] }
    set { self[NoteRepository.self] = newValue }
  }
}
