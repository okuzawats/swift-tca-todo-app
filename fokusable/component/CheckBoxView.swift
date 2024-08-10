import SwiftUI

/// チェックボックスのコンポーネント
///
/// チェックボックスの未チェック状態、チェック状態を切り替えることのできるコンポーネント。
/// SF Symbolsを用いている。
struct CheckBoxView: View {
  private var isChecked: Bool
  
  /// - Parameters:
  ///   - isChecked: If true, check box is checked.
  init(isChecked: Bool) {
    self.isChecked = isChecked
  }
  
  var body: some View {
    if (isChecked) {
      Image(systemName: "checkmark.square")
    } else {
      Image(systemName: "square")
    }
  }
}
