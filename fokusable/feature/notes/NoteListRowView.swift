import SwiftUI

/// ノートの一覧表示における一行分のView
///
/// - Parameters:
///   - note: ノートを表すデータ
///   - onCheckBoxTapped: ノートのチェックをタップした時のコールバック
///   - onSaveButtonTapped: ノートの保存をタップした時のコールバック
///   - onEditButtonTapped: ノートの編集をタップした時のコールバック
struct NoteListRowView: View {
  var note: NoteItem
  var onCheckBoxTapped: (NoteItem) -> Void
  var onSaveButtonTapped: (NoteItem, String) -> Void
  var onEditButtonTapped: (NoteItem) -> Void

  var body: some View {
    HStack {
      CheckBoxView(isChecked: note.isDone, onChecked: { _ in onCheckBoxTapped(note) })
      
      if (note.isEdit) {
        NoteListInputView(note: note, onInputFinished: onSaveButtonTapped)
      } else {
        NoteListItemView(note: note, onFocused: onEditButtonTapped)
      }
    }
  }
}
