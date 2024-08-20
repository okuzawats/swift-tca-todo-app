import ComposableArchitecture
import Dependencies
import Foundation
import SwiftData

/// NoteRepositoryで発生するエラー型
enum NoteRepositoryError: Error {
  /// 読み込み失敗を表すエラー型
  case fetchError
  /// 要求されたデータモデルが存在しないことを表すエラー型
  case noEntityError
  /// 保存失敗を表すエラー型
  case insertionError
}

/// ノート集約に対するRepository
struct NoteRepository {
  /// 日付IDを用いて、対応するノートを取得する。
  var fetchByDayId: (UUID) async -> Result<IdentifiedArrayOf<NoteItem>, NoteRepositoryError>
  // ノートを保存する。
  var save: (NoteItem) async -> Result<Void, NoteRepositoryError>
}

extension NoteRepository: DependencyKey {
  static let liveValue: NoteRepository = Self(
    fetchByDayId: { dayId in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      
      @Dependency(\.noteMapper)
      var mapper: NoteMapper
      
      let fetchDescriptor = FetchDescriptor<Note>(
        // 日付IDが等しいノートのみを取得するためのQuery
        predicate: #Predicate { $0.dayId == dayId }
      )
      
      do {
        let allNote = try context.fetch(fetchDescriptor)
        return .success(mapper.toPresentation(allNote))
      } catch {
        return .failure(.fetchError)
      }
    },
    save: { noteItem in
      @Dependency(\.noteDatabase.context)
      var context: ModelContext
      
      @Dependency(\.noteMapper)
      var mapper: NoteMapper
      
      do {
        context.insert(mapper.toData(noteItem))
        try context.save()
        return .success(())
      } catch {
        return .failure(.insertionError)
      }
    }
  )
  
  static let previewValue: NoteRepository = Self(
    fetchByDayId: { _ in
      return .success([])
    },
    save: { _ in
      return .success(())
    }
  )
}

extension DependencyValues {
  var noteRepository: NoteRepository {
    get { self[NoteRepository.self] }
    set { self[NoteRepository.self] = newValue }
  }
}
