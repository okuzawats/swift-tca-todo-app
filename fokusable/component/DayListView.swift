import ComposableArchitecture
import SwiftUI

/// 日付の一覧表示を行うView
struct DayListView: View {
  var days: IdentifiedArrayOf<DayItem>
  var onDayTapped: (DayItem) -> Void
  
  var body: some View {
    List {
      ForEach(days) { dayItem in
        Text("\(dayItem.day)")
          .onTapGesture {
            onDayTapped(dayItem)
          }
      }
    }
  }
}
