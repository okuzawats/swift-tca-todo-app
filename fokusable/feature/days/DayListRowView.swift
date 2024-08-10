import SwiftUI

/// 日付の一覧表示における一行分のView
///
/// - Parameters:
///   - day:日付を表すデータ
///   - onDayTapped: 日付がタップされた時のコールバック
struct DayListRowView: View {
  var day: DayItem
  var onDayTapped: (DayItem) -> Void

  var body: some View {
    Text("\(day.day)")
      .onTapGesture { onDayTapped(day) }
  }
}
