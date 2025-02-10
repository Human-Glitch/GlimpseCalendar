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
	
	// Cache events keyed by year.
	private var eventsCache: [Int: [EKEvent]] = [:]
	
	func requestAccess(forYear year: Int) {
		eventStore.requestFullAccessToEvents { [weak self] (granted, error) in
			guard let self = self else { return }
			if granted {
				Task { [weak self] in
					guard let self = self else { return }
					let events = await self.fetchEkEventsAsync(forYear: year)
					await MainActor.run { self.ekEvents = events }
				}
			} else {
				print("Access denied or error: \(String(describing: error))")
			}
		}
	}
	
	func fetchEkEventsAsync(forYear year: Int) async -> [EKEvent] {
		if let cached = eventsCache[year] {
			return cached
		}
		return await withUnsafeContinuation { continuation in
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
			eventsCache[year] = events
			continuation.resume(returning: events)
		}
	}
}
