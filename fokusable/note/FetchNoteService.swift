import ComposableArchitecture
import Dependencies
import Foundation

/// ノートの読み込み失敗を表す例外型
struct FetchNoteError: Error {}

/// ノートの読み込み機能を提供するサービス
struct FetchNoteService {
  /// 日付IDを用いてノートを取得する。
  var fetchByDayId: (UUID) async -> Result<IdentifiedArrayOf<NoteItem>, FetchNoteError>
}

extension FetchNoteService: DependencyKey {
  static let liveValue: FetchNoteService = Self(
    fetchByDayId: { dayId in
      @Dependency(\.noteRepository)
      var repository: NoteRepository
      
      switch await repository.fetchByDayId(dayId) {
      case .success(let note):
        return .success(note)
      case .failure(let error):
        return .failure(FetchNoteError())
      }
    }
  )
  
  static let previewValue: FetchNoteService = Self(
    fetchByDayId: { id in
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
