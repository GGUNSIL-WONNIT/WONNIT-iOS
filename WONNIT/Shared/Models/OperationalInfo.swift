import Foundation

struct OperationalInfo: Equatable, Hashable, Codable {
    var dayOfWeeks: [DayOfWeek]
    var startAt: DateComponents
    var endAt: DateComponents

    enum CodingKeys: String, CodingKey {
        case dayOfWeeks, startAt, endAt
    }

    init(dayOfWeeks: [DayOfWeek], startAt: DateComponents, endAt: DateComponents) {
        self.dayOfWeeks = dayOfWeeks
        self.startAt = startAt
        self.endAt = endAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dayOfWeeks = try container.decode([DayOfWeek].self, forKey: .dayOfWeeks)

        let startAtString = try container.decode(String.self, forKey: .startAt)
        let endAtString = try container.decode(String.self, forKey: .endAt)

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let alternativeFormatter = ISO8601DateFormatter()
        alternativeFormatter.formatOptions = [.withInternetDateTime]

        guard let startDate = formatter.date(from: startAtString) ?? alternativeFormatter.date(from: startAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .startAt, in: container, debugDescription: "Start date string does not match expected format.")
        }
        
        guard let endDate = formatter.date(from: endAtString) ?? alternativeFormatter.date(from: endAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .endAt, in: container, debugDescription: "End date string does not match expected format.")
        }

        let calendar = Calendar.current
        startAt = calendar.dateComponents([.hour, .minute], from: startDate)
        endAt = calendar.dateComponents([.hour, .minute], from: endDate)
    }
}

enum DayOfWeek: String, Codable, Equatable, CaseIterable {
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}
