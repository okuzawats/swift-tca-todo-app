import ComposableArchitecture
import Dependencies

struct DayMapper {
  var toPresentations: ([Day]) -> IdentifiedArrayOf<DayItem>
  var toPresentation: (Day) -> DayItem
  var toData: (DayItem) -> Day
}

extension DayMapper: DependencyKey {
  static let liveValue: DayMapper = Self(
    toPresentations: { days in
      let elements = days
        .map { day in
          DayItem(id: day.id, day: day.date)
        }
        .sorted(by: >)
      
      return IdentifiedArrayOf(uniqueElements: elements)
    },
    toPresentation: { day in
      return DayItem(id: day.id, day: day.date)
    },
    toData: { dayItem in
      return Day(id: dayItem.id, date: dayItem.date)
    }
  )
  
  static let previewValue: DayMapper = Self(
    toPresentations: { days in
      let elements = days
        .map { day in
          DayItem(id: day.id, day: day.date)
        }
        .sorted(by: >)
      
      return IdentifiedArrayOf(uniqueElements: elements)
    },
    toPresentation: { day in
      DayItem(id: day.id, day: day.date)
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
