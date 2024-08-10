import SwiftUI

/// チェックボックスのコンポーネント
///
/// チェックボックスの未チェック状態、チェック状態を切り替えることのできるコンポーネント。
/// SF Symbolsを用いている。
/// - Parameters:
///   - isChecked: trueの場合はチェック済み、falseの場合は未チェックを表示する。
///   - onChecked: チェックボックスがタップされた時のコールバック。チェックされた時はtrue、チェックが外された時はfalseを渡す。
struct CheckBoxView: View {
  var isChecked: Bool
  var onChecked: (Bool) -> Void
  
  var body: some View {
    if (isChecked) {
      Image(systemName: "checkmark.square")
        .onTapGesture {
          onChecked(true)
        }
    } else {
      Image(systemName: "square")
        .onTapGesture {
          onChecked(false)
        }
    }
  }
}
