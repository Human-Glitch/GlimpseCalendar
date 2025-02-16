//
//  CalendarFactory.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI
import Foundation

struct CalendarFactory {
	private static let weekdayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE"
		formatter.locale = Locale(identifier: "en_US")
		return formatter
	}()
	
	private static let monthFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM"
		formatter.locale = Locale(identifier: "en_US")
		return formatter
	}()
	
	private static let calendar: Calendar = {
		var calendar = Calendar.current
		calendar.firstWeekday = 1 // Sunday
		return calendar
	}()
	
	static var daysOfWeek: [String] {
		let calendar = Calendar.current
		let dateFormatter = weekdayFormatter
		
		// Start with Sunday (1) and get all 7 days
		return (1...7).map { weekday -> String in
			let date = calendar.date(from: DateComponents(weekday: weekday))!
			return dateFormatter.string(from: date).uppercased()
		}
	}
	
	static let events: [Event] = [
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		
	]
	
	static func getCalendarYear(for thisYear: Date) -> CalendarYear {
		let year = calendar.component(.year, from: thisYear)
		var calendarYear = CalendarYear(year: year)
		var weekNumberCount = 1
		
		let months = (1...12).map { month -> CalendarMonth in
			
			let monthDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
			let monthName = monthFormatter.string(from: monthDate)
			let daysInMonth = getDaysInMonth(for: monthDate)
			
			let calendarDays = daysInMonth.map { date -> CalendarDay in
				CalendarDay(weekDay: getDayOfWeek(for: date), date: date)
			}
			
			let calendarWeeks = createWeeks(from: calendarDays, startingWeekNumber: &weekNumberCount)
			
			return CalendarMonth(month: monthName, calendarWeeks: calendarWeeks)
		}
		
		calendarYear.calendarMonths = months
		return calendarYear
	}
	
	private static func createWeeks(from days: [CalendarDay], startingWeekNumber: inout Int) -> [CalendarWeek] {
		var weeks: [CalendarWeek] = []
		var currentWeek = CalendarWeek(weekNumber: startingWeekNumber)
		var currentDays: [CalendarDay] = []
		
		// Add blank days at start if needed
		let firstWeekday = calendar.component(.weekday, from: days[0].date)
		if firstWeekday > 1 {
			for _ in 1..<firstWeekday {
				currentDays.append(CalendarDay(weekDay: "Blank", date: days[0].date))
			}
		}
		
		// Add all days with proper indexing
		for (index, day) in days.enumerated() {
			var indexedDay = day
			indexedDay.index = currentDays.count
			currentDays.append(indexedDay)
			
			if calendar.component(.weekday, from: day.date) == 7 || index == days.count - 1 {
				currentWeek.calendarDays = currentDays
				weeks.append(currentWeek)
				
				startingWeekNumber += 1
				currentWeek = CalendarWeek(weekNumber: startingWeekNumber)
				currentDays = []
			}
		}
		
		return weeks
	}
	
	static func getDaysInMonth(for date: Date) -> [Date] {
		let calendar = Calendar.current
		let year = calendar.component(.year, from: date)
		let month = calendar.component(.month, from: date)
		let range = calendar.range(of: .day, in: .month, for: date)!
		
		var daysInMonth: [Date] = []
		for day in 1...range.count {
			let components = DateComponents(year: year, month: month, day: day)
			if let date = calendar.date(from: components) {
				daysInMonth.append(date)
			}
		}
		
		return daysInMonth
	}
	
	static func getMonthAndYear(for date: Date) -> String {
		let calendar = Calendar.current
		let year = calendar.component(.year, from: date)
		return "\(year)\n\(monthFormatter.string(from: date))"
		
	}
	
	static func getDayOfWeek(for date: Date) -> String {
		return weekdayFormatter.string(from: date).uppercased()
	}
	
}

struct CalendarYear: Hashable {
	let year: Int
	var calendarMonths: [CalendarMonth] = []
}

struct CalendarMonth: Hashable {
	let month: String
	var calendarWeeks: [CalendarWeek] = []
}

struct CalendarWeek: Hashable{
	var weekNumber: Int
	var calendarDays: [CalendarDay] = []
}

struct CalendarDay: Identifiable, Hashable {
	init(weekDay: String, date: Date, index: Int = 0, events: [Event]? = nil) {
		self.weekDay = weekDay
		self.date = date
		self.index = 0
		self.events = events
	}
	
	let id = UUID()
	var weekDay: String
	let date: Date
	var index: Int
	var events: [Event]?
}
