import Dependencies
import Foundation
import SwiftData

enum NoteRepositoryError: Error {
  case initializationError
  case insertionError
}

struct NoteRepository {
  var save: (Int) async -> Result<String, NoteRepositoryError>
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    save: { _ in
      @Dependency(\.noteDatabase.context)
      var context: () throws -> ModelContext

      let modelContext: ModelContext
      do {
        modelContext = try context()
      } catch {
        return .failure(.initializationError)
      }

      let inserted: Note
      do {
        modelContext.insert(Note(id: UUID()))
        try modelContext.save()
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
