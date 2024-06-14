import ComposableArchitecture
import Dependencies
import Foundation

struct NoteFetchingError: Error {}

struct NoteFetchingService {
  var fetchById: (UUID) async -> Result<IdentifiedArrayOf<NoteItem>, NoteFetchingError>
}

extension NoteFetchingService: DependencyKey {
  static let liveValue: NoteFetchingService = Self(
    fetchById: { id in
      @Dependency(\.noteRepository) var repository: NoteRepository
      @Dependency(\.noteMapper) var mapper: NoteMapper
      
      let notes = await repository.fetch(id)
      switch notes {
      case .success(let note):
        return .success(mapper.toPresentation(note))
      case .failure(let error):
        return .failure(NoteFetchingError())
      }
    }
  )
}

extension DependencyValues {
  var noteFetchingService: NoteFetchingService {
    get { self[NoteFetchingService.self] }
    set { self[NoteFetchingService.self] = newValue }
  }
}
