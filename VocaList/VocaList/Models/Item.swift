// 20250605
// Item Data Model

// @Model triggers scheme generation
// transforms the class' stored properties into persisted ones
// makes the class conform to Observable for reactivity
// "This class should be saved to the DB"

import Foundation
import SwiftData

@Model
class Item {
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date
    var sortOrder: Int
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.completedAt = Date()
        self.sortOrder = Int(Date().timeIntervalSince1970)
    }
}
