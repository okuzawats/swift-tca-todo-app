import Foundation
import SwiftData

/// ノートを表すデータモデル
@Model
final class Note {
  init(id: UUID, status: String, text: String) {
    self.id = id
    self.status = status
    self.text = text
  }

  /// ノートを表すデータモデルのプライマリキーとなるid
  @Attribute(.unique)
  let id: UUID

  /// ノートのステータスを表す文字列
  ///
  /// 空文字: 未完了
  /// X: 完了
  let status: String

  /// ノートの本文
  let text: String
}
