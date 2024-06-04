import Dependencies
import Foundation
import SwiftData

enum NoteRepositoryError: Error {
  case fetchError
  case noEntityError
  case insertionError
}

struct NoteRepository {
  var fetch: (UUID) async -> Result<Note, NoteRepositoryError>
  var save: (Int) async -> Result<String, NoteRepositoryError>
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    fetch: { id in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      let fetchDispatcher = FetchDescriptor<Note>(
        predicate: #Predicate {
          $0.id == id
        }
      )
      let allNote: [Note]
      do {
        allNote = try context.fetch(fetchDispatcher)
      } catch {
        return .failure(.fetchError)
      }

      // TODO transform Note to non-db-dependent type
      if (allNote.isEmpty) {
        return .failure(.noEntityError)
      } else {
        let note = allNote[0]
        return .success(note)
      }
    },
    save: { _ in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext

      let inserted: Note
      do {
        context.insert(Note(id: UUID(), text: "foo"))
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
