import Foundation
import SwiftUI

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        
        /// Set the date format pattern
        formatter.dateFormat = format
        /// Return the date as a string using the specified format
        return formatter.string(from: self)
    }
    
    /// Checking Whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        /// Normalize the date to 00:00 to avoid time-based issues when calculating the week range
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        
        /// Get the DateInterval representing the week that includes the given date
        /// 'of' specifies the unit (week of month), 'for' is the reference date
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        /// Safely unwrap the start date of the week and assign it to startOfWeek
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        /// ７日分の値をweekDay型に初期化して、week配列に代入する、byAddingで日付単位になっている通り、valueが一づつ増えると日付単位でdate型のデータがweekDayに入る仕組み
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    /// Creating Next Week,
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    /// Creating last Week,
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

extension View {
    
    /// Checking Two dates are same
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
