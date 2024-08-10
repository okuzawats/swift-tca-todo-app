import SwiftUI

/// チェックボックスのコンポーネント
///
/// チェックボックスの未チェック状態、チェック状態を切り替えることのできるコンポーネント。
/// SF Symbolsを用いている。
/// - Parameters:
///   - isChecked: If true, check box is checked.
struct CheckBoxView: View {
  var isChecked: Bool
  
  var body: some View {
    if (isChecked) {
      Image(systemName: "checkmark.square")
    } else {
      Image(systemName: "square")
    }
  }
}
