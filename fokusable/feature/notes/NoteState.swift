import ComposableArchitecture

/// ノートの表示状態を表す型
enum NoteState: Equatable {
  /// 空表示状態
  case empty

  /// 一覧表示状態
  /// - Parameters:
  ///   - items: 一覧表示するノートの配列
  case list(items: IdentifiedArrayOf<NoteItem>)

  /// エラー表示状態
  case error
}
