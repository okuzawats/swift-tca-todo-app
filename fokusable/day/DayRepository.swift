import ComposableArchitecture
import Dependencies
import Foundation
import SwiftData

/// DayRepositoryで発生し得るエラー型
enum DayRepositoryError: Error {
  /// 読み込み失敗を表すエラー型
  case fetchError
  /// 保存失敗を表すエラー型
  case insertionError
}

/// 日付集約に対するリポジトリ
struct DayRepository {
  /// 全ての日付を取得する。
  var fetchAll: () async -> Result<IdentifiedArrayOf<DayItem>, DayRepositoryError>
  /// 当日の日付を取得する。
  ///
  /// - Parameters:
  ///   - 日付の文字列表現を受け取る。
  var fetchToday: (String) async -> Result<DayItem, DayRepositoryError>
  /// 日付を保存する。
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
      do {
        let allDay = try context.fetch(fetchDispatcher)
        return .success(mapper.toPresentations(allDay))
      } catch {
        return .failure(.fetchError)
      }
    },
    fetchToday: { date in
      @Dependency(\.dayDatabase.context)
      var context: ModelContext
      
      @Dependency(\.dayMapper)
      var mapper: DayMapper
      
      let fetchDispatcher = FetchDescriptor<Day>(
        predicate: #Predicate { $0.date == date }
      )
      do {
        let today: Day = try context.fetch(fetchDispatcher)[0]
        return .success(mapper.toPresentation(today))
      } catch {
        return .failure(.fetchError)
      }
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
    fetchToday: {_ in 
      return .success(DayItem(id: UUID(), day: "2024/08/20"))
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
