import ComposableArchitecture
import SwiftUI

/// ノートの一覧表示を行うView
///
/// - Parameters:
///   - notes: ノートを表すデータの配列
///   - onNoteChecked: ノートのチェックをタップした時のコールバック
///   - onNoteSaved:
struct NoteListView: View {
  var notes: IdentifiedArrayOf<NoteItem>
  var onCheckBoxTapped: (NoteItem) -> Void
  var onSaveButtonTapped: (NoteItem, String) -> Void
  var onEditButtonTapped: (NoteItem) -> Void
  
  @State var editingText = "" // 編集中のテキスト
  @FocusState var focus: Bool? // 編集中のTextFieldにフォーカスを与えるために使用する値
  
  var body: some View {
    List {
      ForEach(notes) { note in
        HStack {
          CheckBoxView(isChecked: note.isDone)
            .onTapGesture {
              onCheckBoxTapped(note)
            }
          
          if (note.isEdit) {
            TextField("Enter Your TODO here.", text: $editingText)
              .textFieldStyle(DefaultTextFieldStyle())
              .focused($focus, equals: true)
              .onSubmit {
                onSaveButtonTapped(note, editingText)
                editingText = "" // 保存した時、テキストを空にする
              }
              .onAppear {
                editingText = note.text
                focus = true
              }
              .onDisappear {
                focus = nil
              }
          } else {
            Text("\(note.text)")
              .lineLimit(1)
              .fixedSize(horizontal: false, vertical: true)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(.white) // タップを有効化するために必要
              .onTapGesture {
                onEditButtonTapped(note)
              }
          }
        }
        .listRowSeparator(.hidden)
        .padding(.bottom, 4)
      }
    }
  }
}
