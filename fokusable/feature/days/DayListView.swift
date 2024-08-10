import ComposableArchitecture
import SwiftUI

/// 日付の一覧表示を行うView
///
/// - Parameters:
///   - days: 日付を表すデータの配列
///   - onDayTapped: 日付をタップした時のコールバック
struct DayListView: View {
  var days: IdentifiedArrayOf<DayItem>
  var onDayTapped: (DayItem) -> Void
  
  var body: some View {
    List {
      ForEach(days) { day in
        DayListRowView(
          day: day,
          onDayTapped: onDayTapped
        )
      }
    }
  }
}
