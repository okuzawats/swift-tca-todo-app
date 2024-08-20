import SwiftData

/// SwiftDataのModelContainerを管理するための型
///
/// ModelContainerのインスタンスを `shared` として保持している。
struct FokusableModelContainer {
  static var shared: ModelContainer = {
    let schema = Schema([Day.self, Note.self])
    let configurations = [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)]
    
    do {
      return try ModelContainer(for: schema, configurations: configurations)
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
}
