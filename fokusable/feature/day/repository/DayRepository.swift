import Dependencies
import Foundation
import SwiftData

struct DayRepository {
  var save: (Int) async throws -> String
}

extension DayRepository: DependencyKey {
  static let liveValue: DayRepository = Self(
    save: { _ in
      @Dependency(\.dayDatabase.context) var context
      let dayContext = try context()
      dayContext.insert(Day(id: UUID()))
      try dayContext.save()
      return "bar"
    }
  )
}

extension DependencyValues {
  var dayRepository: DayRepository {
    get { self[DayRepository.self] }
    set { self[DayRepository.self] = newValue }
  }
}
