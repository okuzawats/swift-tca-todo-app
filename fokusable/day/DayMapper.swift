import ComposableArchitecture
import Dependencies

struct DayMapper {
  var toPresentation: ([Day]) -> IdentifiedArrayOf<DayItem>
  var toData: (DayItem) -> Day
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
    },
    toData: { dayItem in
      return Day(id: dayItem.id, date: dayItem.date)
    }
  )

  static let previewValue: DayMapper = Self(
    toPresentation: { days in
      let elements = days
        .map { day in
          DayItem(id: day.id, day: day.date)
        }
        .sorted(by: >)
      
      return IdentifiedArrayOf(uniqueElements: elements)
    },
    toData: { Day(id: $0.id, date: $0.date) }
  )
}

extension DependencyValues {
  var dayMapper: DayMapper {
    get { self[DayMapper.self] }
    set { self[DayMapper.self] = newValue }
  }
}
