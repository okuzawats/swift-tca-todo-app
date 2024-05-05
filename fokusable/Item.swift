//
//  Item.swift
//  fokusable
//
//  Created by Toshiki Okuzawa on 2024/05/06.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
