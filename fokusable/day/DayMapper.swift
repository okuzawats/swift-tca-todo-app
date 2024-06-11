import ComposableArchitecture
import Dependencies

struct DayMapper {
  var toPresentation: ([Day]) -> IdentifiedArrayOf<DayItem>
}

extension DayMapper: DependencyKey {
  static let liveValue: DayMapper = Self(
    toPresentation: { days in
      let elements = days
        .map { day in
          DayItem(id: day.id, day: day.date)
        }
        .sorted(by: >)
      
      return IdentifiedArrayOf(uniqueElements: elements)
    }
  )
}

extension DependencyValues {
  var dayMapper: DayMapper {
    get { self[DayMapper.self] }
    set { self[DayMapper.self] = newValue }
  }
}
