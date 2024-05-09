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
  do {
    let container = try ModelContainer(for: Day.self)
    return ModelContext(container)
  } catch {
    fatalError("Failed to create container.")
  }
}()
