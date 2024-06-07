import ComposableArchitecture
import Dependencies
import Foundation

struct DayFetchingError: Error {}

struct DayFetchingService {
  var fetchAll: () async -> Result<IdentifiedArrayOf<DayItem>, DayFetchingError>
  var fetchToday: () async -> Result<DayItem, DayFetchingError>
}

extension DayFetchingService: DependencyKey {
  static let liveValue: DayFetchingService = Self(
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
        return .failure(DayFetchingError())
      }
    },
    fetchToday: {
      // TODO implement loading today
      return .success(
        DayItem(id: UUID(), day: "202-06-08")
      )
//      return .failure(DayFetchingError())
    }
  )
}

extension DependencyValues {
  var dayFetchingService: DayFetchingService {
    get { self[DayFetchingService.self] }
    set { self[DayFetchingService.self] = newValue }
  }
}
