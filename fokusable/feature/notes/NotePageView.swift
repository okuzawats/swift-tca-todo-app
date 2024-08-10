import ComposableArchitecture
import SwiftUI

/// ノート表示のルートとなるView。`state` の状態に応じて、表示を切り替える。
///
/// - Parameters:
///   - state: ノートの表示状態
///   - onCheckBoxTapped: ノートのチェックをタップした時のコールバック
///   - onSaveButtonTapped: ノートの保存をタップした時のコールバック
///   - onEditButtonTapped: ノートの編集をタップした時のコールバック
struct NotePageView: View {
  var state: NoteState
  var onCheckBoxTapped: (NoteItem) -> Void
  var onSaveButtonTapped: (NoteItem, String) -> Void
  var onEditButtonTapped: (NoteItem) -> Void

  var body: some View {
    Group {
      switch state {
      case .empty:
        Text("") // ノートが空の場合にdetailのエリアが潰れないようにするための空のView
      case .list(let notes):
        NoteListView(
          notes: notes,
          onCheckBoxTapped: onCheckBoxTapped,
          onSaveButtonTapped: onSaveButtonTapped,
          onEditButtonTapped: onEditButtonTapped
        )
      case .error:
        ErrorView()
      }
    }
  }
}
