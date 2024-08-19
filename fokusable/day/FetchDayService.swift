import ComposableArchitecture
import Dependencies
import Foundation

/// 日付の取得失敗を表すエラー型
struct FetchDayError: Error {}

/// 日付の取得機能を提供するサービス
struct FetchDayService {
  /// すべての日付を取得する
  var fetchAll: () async -> Result<IdentifiedArrayOf<DayItem>, FetchDayError>
  /// 当日の日付を取得する
  var fetchToday: () async -> Result<DayItem, FetchDayError>
}

extension FetchDayService: DependencyKey {
  static let liveValue: FetchDayService = Self(
    fetchAll: {
      @Dependency(\.dayRepository)
      var repository: DayRepository
      
      let allDays = await repository.fetchAll()
      switch allDays {
      case .success(var days):
        let dateOfToday = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let hasCreatedToday = days.contains(where: { day in
          day.date == formatter.string(from: dateOfToday)
        })
        if !hasCreatedToday {
          let today = DayItem(id: UUID(), day: formatter.string(from: dateOfToday))
          let _ = await repository.save(today)
          days.insert(today, at: 0)
        }
        return .success(days)
      case .failure(let error):
        return .failure(FetchDayError())
      }
    },
    fetchToday: {
      // TODO: implement loading today
      return .success(
        DayItem(id: UUID(), day: "2024-06-08")
      )
      //      return .failure(DayFetchingError())
    }
  )
  
  static let previewValue: FetchDayService = Self(
    fetchAll: {
      return .success([])
    },
    fetchToday: {
      return .success(DayItem(id: UUID(), day: "2024/08/06"))
    }
  )
}

extension DependencyValues {
  var fetchDayService: FetchDayService {
    get { self[FetchDayService.self] }
    set { self[FetchDayService.self] = newValue }
  }
}
