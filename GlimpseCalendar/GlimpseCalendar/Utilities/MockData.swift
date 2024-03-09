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
		
		if(_calendarRows.isEmpty == false){
			return _calendarRows
		}
		
		var result: [Int: [CalendarItemView]] = [:]
		
		for count in 1...5 {
			
			var calendarItems: [CalendarItemView] = []
			for day in daysOfWeek {
				let calendarItem = CalendarItemView(date: day)
				calendarItems.append(calendarItem)
			}
			
			result.updateValue(calendarItems, forKey: count)
		}
		
		return result
	}
}
