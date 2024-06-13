//
//  EventKitManager.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 6/2/24.
//

import SwiftUI
import EventKit

class EventKitManager: ObservableObject {
	
	private let eventStore = EKEventStore()
	@Published var ekEvents: [EKEvent] = []
	
	func requestAccess(forYear year: Int) {
		eventStore.requestFullAccessToEvents(completion: { (granted, error) in
			if granted {
				DispatchQueue.main.async {
					self.ekEvents = self.fetchEkEvents(forYear: year)
				}
			} else {
				print("Access denied or error: \(String(describing: error))")
			}
		})
	}
	
	func fetchEkEvents(forYear year: Int) -> [EKEvent] {
		let calendars = eventStore.calendars(for: .event)
		
		var dateComponents = DateComponents()
		dateComponents.year = year
		dateComponents.month = 1
		dateComponents.day = 1
		let startDate = Calendar.current.date(from: dateComponents)!
		
		dateComponents.year = year + 1
		dateComponents.month = 1
		dateComponents.day = 1
		let endDate = Calendar.current.date(from: dateComponents)!
		
		let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
		
		let events = eventStore.events(matching: predicate)
		
		return events
	}
}
