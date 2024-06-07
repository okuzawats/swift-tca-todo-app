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
      return .success(
        [
          NoteItem(id: UUID(), bracket: "X", text: "Done!"),
          NoteItem(id: UUID(), bracket: ">", text: "Postponed"),
          NoteItem(id: UUID(), bracket: "  ", text: "TODO"),
        ]
      )
      //      return .failure(NoteFetchingError())
    }
  )
}

extension DependencyValues {
  var noteFetchingService: NoteFetchingService {
    get { self[NoteFetchingService.self] }
    set { self[NoteFetchingService.self] = newValue }
  }
}
