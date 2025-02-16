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
		let calendar = Calendar.current
		
		let year = calendar.component(.year, from: thisYear)
		var calendarYear: CalendarYear = CalendarYear(year: year)
		
		var calendarMonths: [CalendarMonth] = []
		
		var weekNumberCount = 1
		for month in 1...12 {
			
			let monthDate = DateComponents(calendar: calendar, year: year, month: month, day: 1).date!
			let monthName = monthFormatter.string(from: monthDate)
			
			let daysInMonth = getDaysInMonth(for: monthDate)
			
			var calendarDays: [CalendarDay] = []
			for day in daysInMonth {
				let weekDay = getDayOfWeek(for: day)
				calendarDays.append(CalendarDay(weekDay: weekDay, date: day))
			}
			
			var calendarWeeks: [CalendarWeek] = []
			
			var calendarWeek = CalendarWeek(weekNumber: weekNumberCount)
			for day in calendarDays {
				if (day.weekDay != "SAT") {
					calendarWeek.calendarDays.append(day)
				} else { // add sat and start a new week
					calendarWeek.calendarDays.append(day)
					
					calendarWeeks.append(calendarWeek)
					weekNumberCount = weekNumberCount + 1
					
					calendarWeek = CalendarWeek(weekNumber: weekNumberCount)
				}
			}
			
			while(calendarWeeks[0].calendarDays.count < 7) {
				let blankDay = CalendarDay(weekDay: "Blank", date: Date())
				calendarWeeks[0].calendarDays.insert(blankDay, at: 0)
			}
			
			var weekCount = 0
			for calendarWeek in calendarWeeks {
				
				var dayCount = 0
				for _ in calendarWeek.calendarDays {
					calendarWeeks[weekCount].calendarDays[dayCount].index = dayCount
					dayCount += 1
				}
				
				weekCount += 1
			}
			
			if(calendarWeek.calendarDays.count > 0) {
				calendarWeeks.append(calendarWeek)
			}
			
			let calendarMonth = CalendarMonth(month: monthName, calendarWeeks: calendarWeeks)
			calendarMonths.append(calendarMonth)
		}
		
		calendarYear.calendarMonths = calendarMonths
	  
		return calendarYear
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
