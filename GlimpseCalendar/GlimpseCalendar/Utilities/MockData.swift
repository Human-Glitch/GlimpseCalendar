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
		
		for count in 0...5 {
			var calendarItems: [CalendarItemView] = []
			
			var isHeader = false
			
			if(count == 0) {
				isHeader = true
			}
			
			for day in daysOfWeek {
				if let index = daysOfWeek.firstIndex(of: day) {
					let calendarItem = CalendarItemView(isHeader: isHeader, isSelected: false, day: day, index: index)
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
}
