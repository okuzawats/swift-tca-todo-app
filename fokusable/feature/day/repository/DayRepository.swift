import Dependencies
import Foundation
import SwiftData

enum DayRepositoryError: Error {
  case insertionError
}

struct DayRepository {
  var save: (Int) async -> Result<String, DayRepositoryError>
}

extension DayRepository: DependencyKey {
  static let liveValue: DayRepository = Self(
    save: { _ in
      @Dependency(\.dayDatabase.context)
      var context: () -> ModelContext
      let modelContext: ModelContext = context()

      let inserted: Day
      do {
        modelContext.insert(Day(id: UUID()))
        try modelContext.save()
      } catch {
        return .failure(.insertionError)
      }

      return .success("bar")
    }
  )
}

extension DependencyValues {
  var dayRepository: DayRepository {
    get { self[DayRepository.self] }
    set { self[DayRepository.self] = newValue }
  }
}
