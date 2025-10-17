import Foundation
import SwiftData

@Model
final class Trip {
    var id: UUID
    var name: String
    var startDate: Date?
    var endDate: Date?
    var notes: String?
    var budget: Decimal?
    var createdAt: Date

    init(name: String, startDate: Date? = nil, endDate: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.createdAt = Date()
    }
}
