import ComposableArchitecture
import Dependencies
import Foundation

struct FetchDayError: Error {}

struct FetchDayService {
  var fetchAll: () async -> Result<IdentifiedArrayOf<DayItem>, FetchDayError>
  var fetchToday: () async -> Result<DayItem, FetchDayError>
}

extension FetchDayService: DependencyKey {
  static let liveValue: FetchDayService = Self(
    fetchAll: {
      @Dependency(\.dayRepository) var repository: DayRepository
      @Dependency(\.dayMapper) var mapper: DayMapper
      
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
          let today = Day(
            id: UUID(),
            date: formatter.string(from: dateOfToday)
          )
          let _ = await repository.save(today)
          days.insert(today, at: 0)
        }
        return .success(mapper.toPresentation(days))
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
  
  static let previewValue = Self(
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
