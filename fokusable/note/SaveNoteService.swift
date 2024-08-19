import ComposableArchitecture
import Dependencies
import Foundation

/// ノートの保存失敗を表す例外型
struct SaveNoteError: Error {}

/// ノートの保存機能を提供するサービス
struct SaveNoteService {
  /// ノートを保存する。
  var save: (NoteItem) async -> Result<Void, SaveNoteError>
}

extension SaveNoteService: DependencyKey {
  static let liveValue: SaveNoteService = Self(
    save: { note in
      @Dependency(\.noteRepository)
      var repository: NoteRepository
      
      switch await repository.save(note) {
      case .success:
        return .success(())
      case .failure:
        return .failure(SaveNoteError())
      }
    }
  )
  
  static let previewValue: SaveNoteService = Self(
    save: { _ in
      return .success(())
    }
  )
}

extension DependencyValues {
  var saveNoteService: SaveNoteService {
    get { self[SaveNoteService.self] }
    set { self[SaveNoteService.self] = newValue }
  }
}
