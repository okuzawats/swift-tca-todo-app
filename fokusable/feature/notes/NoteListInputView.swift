import SwiftUI

/// 個々のノートを編集するView
///
/// - Parameters:
///   - note: 個々のノートを表すデータ
///   - onInputFinished: ノートの編集が完了した時のコールバック
struct NoteListInputView: View {
  var note: NoteItem
  var onInputFinished: (NoteItem, String) -> Void

  @State private var editingText = "" // 編集中のテキスト
  @FocusState private var focus: Bool? // 編集中のTextFieldにフォーカスを与えるために使用する値
  
  var body: some View {
    TextField("Enter Your TODO here.", text: $editingText)
      .textFieldStyle(DefaultTextFieldStyle())
      .focused($focus, equals: true)
      .onSubmit { onInputFinished(note, editingText) }
      .onAppear {
        editingText = note.text
        focus = true
      }
      .onDisappear {
        focus = nil
      }
  }
}
