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
	static private var _calendarRows: [Int: [CalendarItemView]]  = [:]
	
	static var calendarRows: [Int: [CalendarItemView]] {
		
		if(_calendarRows.count > 0){
			return _calendarRows
		}
		
		var result: [Int: [CalendarItemView]] = [:]
		
		for count in 0...4 {
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
