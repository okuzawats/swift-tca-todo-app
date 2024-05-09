import Dependencies
import Foundation
import SwiftData

enum NoteRepositoryError: Error {
  case insertionError
}

struct NoteRepository {
  var save: (Int) async -> Result<String, NoteRepositoryError>
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    save: { _ in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext

      let inserted: Note
      do {
        context.insert(Note(id: UUID()))
        try context.save()
      } catch {
        return .failure(.insertionError)
      }

      return .success("foo")
    }
  )
}

extension DependencyValues {
  var noteRepository: NoteRepository {
    get { self[NoteRepository.self] }
    set { self[NoteRepository.self] = newValue }
  }
}
