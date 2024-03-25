//
//  GlimpseCalendarApp.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI

@main
struct GlimpseCalendarApp: App {
	var calendarRows = MockData.calendarRows
	
    var body: some Scene {
        WindowGroup {
			CalendarView(calendarRows: calendarRows)
        }
    }
}
