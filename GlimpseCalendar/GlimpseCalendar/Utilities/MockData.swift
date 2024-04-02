//
//  MockData.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI
import Foundation

struct MockData {
	
	static let daysOfWeek: [String] = [
		"SUN",
		"MON",
		"TUE",
		"WED",
		"THU",
		"FRI",
		"SAT"
	]
	
	static let monthsOfYear: [String] = [
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	]
	
	static private var _calendarRows: [Int: [CalendarItemView]]  = [:]
	
	static var calendarRows: [Int: [CalendarItemView]] {
		
		if(_calendarRows.count > 0){
			return _calendarRows
		}
		
		var result: [Int: [CalendarItemView]] = [:]
		
		for count in 1...4 {
			var calendarItems: [CalendarItemView] = []
			
			for day in daysOfWeek {
				if let index = daysOfWeek.firstIndex(of: day) {
					let calendarItem = CalendarItemView(day: day, index: index)
					calendarItems.append(calendarItem)
				} else {
					print("Failed to grab index")
				}
			}
			
			result.updateValue(calendarItems, forKey: count)
		}
		
		_calendarRows = result;
		
		return result
	}
	
	static func getDaysOfWeekInYear(for date: Date) -> [(date: Date, weekday: String)] {
		let calendar = Calendar.current
		let year = calendar.component(.year, from: date)

		// Create a DateComponents object for the beginning of the year
		var components = DateComponents(year: year, month: 1, day: 1)

		// Get the total number of days in the year
		let dateInNextYear = calendar.date(byAdding: .year, value: 1, to: components.date!)!
		let daysInYear = calendar.dateComponents([.day], from: components.date!, to: dateInNextYear).day!

		var daysOfWeekInYear: [(date: Date, weekday: String)] = []
		let weekdayFormatter = DateFormatter()
		weekdayFormatter.dateFormat = "EEEE" // Full weekday name (e.g., Tuesday)

		for _ in 1...daysInYear {
			let dayDate = components.date!
			let weekday = weekdayFormatter.string(from: dayDate)
			daysOfWeekInYear.append((date: dayDate, weekday: weekday))
			
			let newDate = calendar.date(byAdding: .day, value: 1, to: components.date!)!
			components = calendar.dateComponents([.year, .month, .day], from: newDate)
	  }
	  
	  return daysOfWeekInYear
	}
	
	static func getCalendarYear(for thisYear: Date) -> CalendarYear {
		let calendar = Calendar.current
		
		let year = calendar.component(.year, from: thisYear)
		var calendarYear: CalendarYear = CalendarYear(year: year)
		
		var calendarMonths: [CalendarMonth] = []
		
		var weekNumberCount = 1
		for month in 1...12 {
			let monthName: String = monthsOfYear[month - 1]
			let monthDate = DateComponents(calendar: calendar, year: year, month: month, day: 1).date!
			
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
			
			if(calendarWeek.calendarDays.count > 0) {
				calendarWeeks.append(calendarWeek)
			}
			
			var calendarMonth = CalendarMonth(month: monthName, calendarWeeks: calendarWeeks)
			calendarMonths.append(calendarMonth)
		}
		
		calendarYear.calendarMonths = calendarMonths
	  
		return calendarYear
	}
	
	static func getDaysInMonth(for date: Date) -> [Date] {
		let calendar = Calendar.current
		let range = calendar.range(of: .day, in: .month, for: date)!
		
		var daysInMonth: [Date] = []
		for day in 1...range.count {
			daysInMonth.append(
				calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
					.addingTimeInterval(TimeInterval(24 * 60 * 60 * (day - 1))))
		}
		
		return daysInMonth
	}
	
	static func getDayOfWeek(for date: Date) -> String {
		let calendar = Calendar.current
		let weekday = calendar.component(.weekday, from: date)
		let weekdays = [
			"SUN",
			"MON",
			"TUE",
			"WED",
			"THU",
			"FRI",
			"SAT"
		]
		
		return weekdays[weekday - 1]
	}
	
}

struct CalendarYear {
	let year: Int
	var calendarMonths: [CalendarMonth] = []
}

struct CalendarMonth {
	let month: String
	var calendarWeeks: [CalendarWeek] = []
}

struct CalendarWeek {
	var weekNumber: Int
	var calendarDays: [CalendarDay] = []
}

struct CalendarDay: Hashable {
	let weekDay: String
	let date: Date
}
