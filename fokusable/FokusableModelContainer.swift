import SwiftData

struct FokusableModelContainer {
  static var shared: ModelContainer = {
    let schema = Schema([
      Day.self,
      Note.self
    ])
    let configurations = [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)]
    do {
      return try ModelContainer(for: schema, configurations: configurations)
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
}
