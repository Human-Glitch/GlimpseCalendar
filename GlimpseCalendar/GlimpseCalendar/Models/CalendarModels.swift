import Foundation

struct CalendarYear: Hashable {
    let year: Int
    var calendarMonths: [CalendarMonth] = []
}

struct CalendarMonth: Hashable {
    let month: String
    var calendarWeeks: [CalendarWeek] = []
}

struct CalendarWeek: Hashable {
    var weekNumber: Int
    var calendarDays: [CalendarDay] = []
}

struct CalendarDay: Identifiable, Hashable {
    let id = UUID()
    var weekDay: String
    let date: Date
    var index: Int
    var events: [Event]?
    
    init(weekDay: String, date: Date, index: Int = 0, events: [Event]? = nil) {
        self.weekDay = weekDay
        self.date = date
        self.index = index
        self.events = events
    }
}
