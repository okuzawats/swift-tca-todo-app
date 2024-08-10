import ComposableArchitecture

/// 日付表示の状態を表す型
enum DayState: Equatable {
  /// 空表示状態
  case empty

  /// 一覧表示状態
  /// - Parameters:
  ///   - items: 日付の配列
  case list(items: IdentifiedArrayOf<DayItem>)

  /// エラー表示状態
  case error
}
