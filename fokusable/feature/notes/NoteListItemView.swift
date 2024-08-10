import SwiftUI

/// 個々のノートを表示するView
///
/// - Parameters:
///   - note: 個々のノートを表すデータ
///   - onFocused: ノートがフォーカスされた時のコールバック
struct NoteListItemView: View {
  var note: NoteItem
  var onFocused: (NoteItem) -> Void
  
  var body: some View {
    // Textタップ時のコールバックを有効化するため、backgroundの指定が必要
    Text(note.text)
      .lineLimit(1)
      .fixedSize(horizontal: false, vertical: true)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.white)
      .onTapGesture { onFocused(note) }
  }
}
