import Dependencies
import Foundation
import SwiftData

enum NoteRepositoryError: Error {
  case fetchError
  case noEntityError
  case insertionError
}

struct NoteRepository {
  var fetch: (UUID) async -> Result<[Note], NoteRepositoryError>
  var save: (Note) async -> Result<Void, NoteRepositoryError>
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
      
      // TODO: transform Note to non-db-dependent type
      return .success(allNote)
    },
    save: { note in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      
      do {
        context.insert(note)
        try context.save()
      } catch {
        return .failure(.insertionError)
      }
      
      return .success(())
    }
  )
  
  static let previewValue = Self(
    fetch: { _ in
      return .success([Note(id: UUID(), status: "", text: "This is a test data.")])
    },
    save: { _ in
      return .success(())
    }
  )
}

extension DependencyValues {
  var noteRepository: NoteRepository {
    get { self[NoteRepository.self] }
    set { self[NoteRepository.self] = newValue }
  }
}
