import ComposableArchitecture
import Dependencies
import Foundation

/// ノートの読み込み失敗を表す例外型
struct FetchNoteError: Error {}

/// ノートの読み込み機能を提供するサービス
struct FetchNoteService {
  /// ノートのIDを用いてノートを取得する。
  var fetchById: (UUID) async -> Result<IdentifiedArrayOf<NoteItem>, FetchNoteError>
}

extension FetchNoteService: DependencyKey {
  static let liveValue: FetchNoteService = Self(
    fetchById: { id in
      @Dependency(\.noteRepository)
      var repository: NoteRepository
      
      @Dependency(\.noteMapper)
      var mapper: NoteMapper
      
      let notes = await repository.fetch(id)
      
      switch notes {
      case .success(let note):
        return .success(mapper.toPresentation(note))
      case .failure(let error):
        return .failure(FetchNoteError())
      }
    }
  )
  
  static let previewValue = Self(
    fetchById: {_ in 
      return .success([])
    }
  )
}

extension DependencyValues {
  var fetchNoteService: FetchNoteService {
    get { self[FetchNoteService.self] }
    set { self[FetchNoteService.self] = newValue }
  }
}
