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
	
	// SwiftData container
	let container: ModelContainer = {
		let schema = Schema([Event.self])
		let container = try! ModelContainer(for: schema, configurations: [])
		return container
	}()
	
	// Create shared service instances - no longer using lazy initialization
	let eventKitManager = EventKitManager()
	
	// Initialize properties in init() instead of using lazy
	private let dataService: DataService
	private let calendarViewModel: CalendarViewModel
	
	init() {
		let context = ModelContext(container)
		self.dataService = DataService(modelContext: context)
		self.calendarViewModel = CalendarViewModel(
			eventKitManager: eventKitManager,
			dataService: dataService
		)
	}
	
    var body: some Scene {
        WindowGroup {
			CalendarView(viewModel: calendarViewModel)
				.environmentObject(eventKitManager)
				.modelContainer(container)
        }
    }
}
