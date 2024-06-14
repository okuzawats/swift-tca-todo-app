import Dependencies
import Foundation
import SwiftData

enum DayRepositoryError: Error {
  case fetchError
  case insertionError
}

struct DayRepository {
  var fetchAll: () async -> Result<[Day], DayRepositoryError>
  var save: (Day) async -> Result<String, DayRepositoryError>
}

extension DayRepository: DependencyKey {
  static let liveValue: DayRepository = Self(
    fetchAll: {
      @Dependency(\.dayDatabase.context) var context: ModelContext
      
      let fetchDispatcher = FetchDescriptor<Day>()
      let allDay: [Day]
      do {
        allDay = try context.fetch(fetchDispatcher)
      } catch {
        return .failure(.fetchError)
      }
      
      // TODO: transform [Day] to non-db-dependent type
      return .success(allDay)
    },
    save: { day in
      @Dependency(\.dayDatabase.context) var context: ModelContext
      
      let inserted: Day
      do {
        context.insert(day)
        try context.save()
      } catch {
        return .failure(.insertionError)
      }
      
      return .success("bar")
    }
  )

  static let previewValue = Self(
    fetchAll: {
      return .success([])
    },
    save: { _ in
      return .success("baz")
    }
  )
}

extension DependencyValues {
  var dayRepository: DayRepository {
    get { self[DayRepository.self] }
    set { self[DayRepository.self] = newValue }
  }
}
