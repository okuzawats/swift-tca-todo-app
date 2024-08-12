import Foundation

struct DayItem: Equatable, Identifiable {
  let id: UUID
  let date: String
  
  init(id: UUID, day: String) {
    // YYYY-MM-DD
    let pattern: String = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$"#
    let regex: NSRegularExpression = try! NSRegularExpression(pattern: pattern, options: [])
    let range: NSRange = NSRange(location: 0, length: day.utf16.count)
    let match = regex.firstMatch(in: day, range: range)
    precondition(match != nil)
    
    self.id = id
    self.date = day
  }
}

extension DayItem: Comparable {
  static func < (lhs: DayItem, rhs: DayItem) -> Bool {
    let lhsDate = lhs.date.components(separatedBy: "-")
    let rhsDate = rhs.date.components(separatedBy: "-")
    
    if Int(lhsDate[0])! < Int(rhsDate[0])! {
      return true
    }
    if Int(lhsDate[1])! < Int(rhsDate[1])! {
      return true
    }
    if Int(lhsDate[2])! < Int(rhsDate[2])! {
      return true
    }
    return false
  }
}
