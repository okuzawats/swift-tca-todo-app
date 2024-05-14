extension NoteItem {
  /// convert NoteItem to display format.
  ///
  /// the format is like this:
  /// `- [x] buy milk`
  func toPresentation() -> String {
    "- [\(self.bracket)] \(self.text)"
  }
}
