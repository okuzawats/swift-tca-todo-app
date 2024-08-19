import ComposableArchitecture
import Dependencies
import Foundation
import SwiftData

enum NoteRepositoryError: Error {
  case fetchError
  case noEntityError
  case insertionError
}

struct NoteRepository {
  var fetch: (UUID) async -> Result<IdentifiedArrayOf<NoteItem>, NoteRepositoryError>
  var save: (NoteItem) async -> Result<Void, NoteRepositoryError>
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    fetch: { id in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      
      @Dependency(\.noteMapper)
      var mapper: NoteMapper
      
      let fetchDispatcher = FetchDescriptor<Note>(
        // IDが等しいノートのみを取得するためのQuery
        predicate: #Predicate { $0.id == id }
      )
      
      let allNote: [Note]
      do {
        allNote = try context.fetch(fetchDispatcher)
      } catch {
        return .failure(.fetchError)
      }
      
      return .success(mapper.toPresentation(allNote))
    },
    save: { noteItem in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      
      @Dependency(\.noteMapper)
      var mapper: NoteMapper
      
      context.insert(mapper.toData(noteItem))
      do {
        try context.save()
      } catch {
        return .failure(.insertionError)
      }
      
      return .success(())
    }
  )
  
  static let previewValue: NoteRepository = Self(
    fetch: { _ in
      return .success([])
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
