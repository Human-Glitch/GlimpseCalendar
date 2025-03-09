//
//  GlimpseCalendarApp.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI
import SwiftData

@main
struct GlimpseCalendarApp: App {
	
	let container: ModelContainer = {
		let schema = Schema([Event.self])
		let container = try! ModelContainer(for: schema, configurations: [])
		return container
	}()
	
	// Create a single instance of EventKitManager
	let eventKitManager = EventKitManager()
	
    var body: some Scene {
        WindowGroup {
			CalendarView()
				.environmentObject(eventKitManager)
				.modelContainer(container)
        }
    }
}
