import Foundation

public typealias DurationDictionary = [Duration.Component: Int]

/// A Duration object represents a period of time, like "2 months" or "1 day, 1 hour".
public class Duration: Codable, Equatable {

    /// An enumeration for the various components of a duration.
    public enum Component: String, CaseIterable {
        case year, month, week, day, hour, minute, second, millisecond
    }

    // MARK: - Properties

    /// A year or count of years.
    public var year: Int?
    /// A month or count of months.
    public var month: Int?
    /// A week or count of weeks.
    public var week: Int?
    /// A day or count of days.
    public var day: Int?
    /// A hour or count of hours.
    public var hour: Int?
    /// A minute or count of minutes.
    public var minute: Int?
    /// A second or count of seconds.
    public var second: Int?
    /// A millisecond or count of milliseconds.
    public var millisecond: Int?


    // MARK: - Computed Properties

    /// Creates a `DateComponents` object for the `Duration`.
    /// - Returns: `DateComponents` with values of the `Duration`.
    public var dateComponents: DateComponents {
        var daysWithWeeks: Int?
        if let weeks = week {
            // ISO 8601 specifies a week as seven days
            daysWithWeeks = weeks * 7
        }
        if let days = day {
            if daysWithWeeks != nil {
                daysWithWeeks! += days
            } else {
                daysWithWeeks = days
            }
        }

        var nanoseconds: Int?
        if let milliseconds = millisecond {
            nanoseconds = milliseconds * 1_000_000
        }

        return DateComponents(
            year: year,
            month: month,
            day: daysWithWeeks,
            hour: hour,
            minute: minute,
            second: second,
            nanosecond: nanoseconds
        )
    }

    /// Creates a new `Duration` object with inverted values.
    /// - Returns: `Duration` object with inverted values.
    public var inverted: Duration {
        return Duration(
            year: invertOptional(value: year),
            month: invertOptional(value: month),
            week: invertOptional(value: week),
            day: invertOptional(value: day),
            hour: invertOptional(value: hour),
            minute: invertOptional(value: minute),
            second: invertOptional(value: second),
            millisecond: invertOptional(value: millisecond)
        )
    }

    /// ISO 8601 string representation of duration
    public var iso8601: String {
        var isoDuration: String = "P"

        if let year = year { isoDuration += "\(year)Y" }
        if let month = month { isoDuration += "\(month)M" }
        if let week = week { isoDuration += "\(week)W" }
        if let day = day { isoDuration += "\(day)D" }

        if hour != nil || minute != nil || second != nil || millisecond != nil {
            isoDuration += "T"
        }

        var timeComponents: String = ""
        if let hour = hour { timeComponents += "\(hour)H" }
        if let minute = minute { timeComponents += "\(minute)M" }

        let seconds = round(Double(second ?? 0) * 1000.0 + Double(millisecond ?? 0)) / 1000.0
        if seconds != 0 {
            timeComponents += String(format: "%gS", seconds)
        }

        if !timeComponents.isEmpty {
            isoDuration += "\(timeComponents)"
        }

        if isoDuration == "P" {
            isoDuration += "T0S"
        }

        return isoDuration
    }


    // MARK: - Initializer

    /// Creates a new duration, optionally specifying values for its fields.
    public init(
        year: Int? = nil,
        month: Int? = nil,
        week: Int? = nil,
        day: Int? = nil,
        hour: Int? = nil,
        minute: Int? = nil,
        second: Int? = nil,
        millisecond: Int? = nil
    ) {
        self.year = year
        self.month = month
        self.week = week
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
    }

    /// Creates a new duration from a duration dictionary.
    /// - Parameter duration: Duration dictionary.
    public init(fromDictionary duration: DurationDictionary) {
        self.year = duration[.year]
        self.month = duration[.month]
        self.week = duration[.week]
        self.day = duration[.day]
        self.hour = duration[.hour]
        self.minute = duration[.minute]
        self.second = duration[.second]
        self.millisecond = duration[.millisecond]
    }

    /// Creates a duration from an ISO 8601 string.
    /// - Parameter string: ISO 8601 duration string.
    /// - Throws: This function throws an error if the given string can't be parsed as a valid ISO 8601 string.
    public convenience init(fromISO string: String) throws {
        self.init(fromDictionary: try Parser.extractISODuration(from: string))
    }

    /// Creates a new duration by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: This function throws an error if the value is invalid for the given encoder’s format.
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        try self.init(fromISO: value)
    }


    // MARK: - Public Methods

    /// Encodes the elements of this duration into the given encoder in an single value container.
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: This function throws an error if the value is invalid for the given encoder’s format.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(iso8601)
    }

    /// Returns the value of one of the properties, using an enumeration value instead of a property name.
    /// - Parameter component: Component of duration.
    /// - Returns: Value for the specified component.
    public func value(for component: Component) -> Int? {
        switch component {
        case .year:
            return year
        case .month:
            return month
        case .week:
            return week
        case .day:
            return day
        case .hour:
            return hour
        case .minute:
            return minute
        case .second:
            return second
        case .millisecond:
            return millisecond
        }
    }

    /// Set the value of one of the properties, using an enumeration value instead of a property name.
    /// - Parameters:
    ///   - value: The new value for the specified component.
    ///   - component: Component of duration
    public func setValue(_ value: Int, for component: Component) {
        switch component {
        case .year:
            year = value
        case .month:
            month = value
        case .week:
            week = value
        case .day:
            day = value
        case .hour:
            hour = value
        case .minute:
            minute = value
        case .second:
            second = value
        case .millisecond:
            millisecond = value
        }
    }


    // MARK: - Operator Functions

    public static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.year == rhs.year
            && lhs.month == rhs.month
            && lhs.week == rhs.week
            && lhs.day == rhs.day
            && lhs.day == rhs.day
            && lhs.minute == rhs.minute
            && lhs.second == rhs.second
            && lhs.millisecond == rhs.millisecond
    }


    // MARK: - Private Methods

    private func invertOptional(value: Int?) -> Int? {
        guard let value = value else {
            return value
        }

        return -value
    }
}

extension Duration: CustomStringConvertible {
    public var description: String {
        return "Duration(\(iso8601))"
    }
}
