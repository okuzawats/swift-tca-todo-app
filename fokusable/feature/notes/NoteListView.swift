import ComposableArchitecture
import SwiftUI

/// ノートの一覧表示を行うView
///
/// - Parameters:
///   - notes: ノートを表すデータの配列
///   - onCheckBoxTapped: ノートのチェックをタップした時のコールバック
///   - onSaveButtonTapped: ノートの保存をタップした時のコールバック
///   - onEditButtonTapped: ノートの編集をタップした時のコールバック
struct NoteListView: View {
  var notes: IdentifiedArrayOf<NoteItem>
  var onCheckBoxTapped: (NoteItem) -> Void
  var onSaveButtonTapped: (NoteItem, String) -> Void
  var onEditButtonTapped: (NoteItem) -> Void
  
  var body: some View {
    List {
      ForEach(notes) { note in
        NoteListRowView(
          note: note,
          onCheckBoxTapped: onCheckBoxTapped,
          onSaveButtonTapped: onSaveButtonTapped,
          onEditButtonTapped: onEditButtonTapped
        )
        .listRowSeparator(.hidden)
        .padding(.bottom, 4)
      }
    }
  }
}
