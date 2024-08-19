import ComposableArchitecture
import Dependencies
import Foundation
import SwiftData

enum DayRepositoryError: Error {
  case fetchError
  case insertionError
}

struct DayRepository {
  var fetchAll: () async -> Result<IdentifiedArrayOf<DayItem>, DayRepositoryError>
  var save: (DayItem) async -> Result<String, DayRepositoryError>
}

extension DayRepository: DependencyKey {
  static let liveValue: DayRepository = Self(
    fetchAll: {
      @Dependency(\.dayDatabase.context)
      var context: ModelContext

      @Dependency(\.dayMapper)
      var mapper: DayMapper

      let fetchDispatcher = FetchDescriptor<Day>()
      let allDay: [Day]
      do {
        allDay = try context.fetch(fetchDispatcher)
      } catch {
        return .failure(.fetchError)
      }

      return .success(mapper.toPresentation(allDay))
    },
    save: { day in
      @Dependency(\.dayDatabase.context)
      var context: ModelContext

      @Dependency(\.dayMapper)
      var mapper: DayMapper

      context.insert(mapper.toData(day))
      do {
        try context.save()
      } catch {
        return .failure(.insertionError)
      }
      
      return .success("bar")
    }
  )

  static let previewValue: DayRepository = Self(
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
