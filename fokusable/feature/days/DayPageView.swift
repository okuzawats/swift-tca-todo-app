import ComposableArchitecture
import SwiftUI

/// 日付表示のルートとなるView。`state` の状態に応じて、表示を切り替える。
///
/// - Parameters:
///   - state: 日付の表示状態
///   - onDayTapped: 日付がタップされた時のコールバック
struct DayPageView: View {
  var state: DayState
  var onDayTapped: (DayItem) -> Void
  
  var body: some View {
    Group {
      switch state {
      case .empty:
        EmptyView()
      case .list(let days):
        DayListView(
          days: days,
          onDayTapped: onDayTapped
        )
      case .error:
        ErrorView()
      }
    }
  }
}
