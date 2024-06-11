import Foundation

struct DayItem: Equatable, Identifiable {
  let id: UUID
  let day: String
  
  init(id: UUID, day: String) {
    // YYYY-MM-DD
    let pattern: String = #"^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$"#
    let regex: NSRegularExpression = try! NSRegularExpression(pattern: pattern, options: [])
    let range: NSRange = NSRange(location: 0, length: day.utf16.count)
    let match = regex.firstMatch(in: day, range: range)
    precondition(match != nil)
    
    self.id = id
    self.day = day
  }
}
