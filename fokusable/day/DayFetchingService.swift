import ComposableArchitecture
import Dependencies
import Foundation

struct FetchError: Error {}

struct DayFetchingService {
  var invoke: () async -> Result<IdentifiedArrayOf<DayItem>, FetchError>
}

extension DayFetchingService: DependencyKey {
  static let liveValue: DayFetchingService = Self(
    invoke: {
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
        return .failure(FetchError())
      }
    }
  )
}

extension DependencyValues {
  var dayFetchingService: DayFetchingService {
    get { self[DayFetchingService.self] }
    set { self[DayFetchingService.self] = newValue }
  }
}
