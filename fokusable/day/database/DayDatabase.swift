import Dependencies
import SwiftData

struct DayDatabase {
  let context: ModelContext
}

extension DayDatabase: DependencyKey {
  static let liveValue: DayDatabase = Self(
    context: { appContext }()
  )
}

extension DependencyValues {
  var dayDatabase: DayDatabase {
    get { self[DayDatabase.self] }
    set { self[DayDatabase.self] = newValue }
  }
}

fileprivate let appContext: ModelContext = {
  ModelContext(FokusableApp.sharedModelContainer)
}()
