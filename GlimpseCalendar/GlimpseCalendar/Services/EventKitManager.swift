//
//  EventKitManager.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 6/2/24.
//

import SwiftUI
import EventKit
import Combine

enum EventKitError: Error {
    case accessDenied
    case fetchFailed(Error?)
    case unknown
}

class EventKitManager: ObservableObject {
	
	private let eventStore = EKEventStore()
	@Published var ekEvents: [EKEvent] = []
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    @Published var lastError: EventKitError?
	
	// Limit cache size
	private let maxCacheSize = 3
	// Cache events keyed by year.
	private var eventsCache: [Int: [EKEvent]] = [:]
	private var cacheYearOrder: [Int] = [] // Track order for cache cleanup
    
    // Cancellable storage
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Set initial authorization status
        if #available(iOS 17.0, macOS 14.0, *) {
            authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        } else {
            authorizationStatus = EKEventStore.authorizationStatus(for: .event)
        }
        
        // Set up notifications for changes to EventKit
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.clearCache() // Clear cache on external changes
                
                // Re-fetch for the most recent year if we have one
                if let lastYear = self.cacheYearOrder.last {
                    self.requestAccess(forYear: lastYear)
                }
            }
            .store(in: &cancellables)
    }
	
    // Request access using a completion handler or Combine pattern
	func requestAccess(forYear year: Int) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let granted = try await self.requestAccessAsync()
                if granted {
                    let events = await self.fetchEkEventsAsync(forYear: year)
                    await MainActor.run {
                        self.ekEvents = events
                        self.lastError = nil
                    }
                } else {
                    await MainActor.run {
                        self.lastError = .accessDenied
                    }
                }
            } catch {
                await MainActor.run {
                    self.lastError = .fetchFailed(error)
                }
            }
        }
	}
    
    // Async/await version of request access
    func requestAccessAsync() async throws -> Bool {
        if #available(iOS 17.0, macOS 14.0, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            return await withCheckedContinuation { continuation in
                eventStore.requestFullAccessToEvents { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
	
	func fetchEkEventsAsync(forYear year: Int) async -> [EKEvent] {
		if let cached = eventsCache[year] {
			// Move this year to the end of the order (most recently used)
			if let index = cacheYearOrder.firstIndex(of: year) {
				cacheYearOrder.remove(at: index)
			}
			cacheYearOrder.append(year)
			return cached
		}
		
		// Manage cache size
		if cacheYearOrder.count >= maxCacheSize {
			// Remove oldest cache entry
			if let oldestYear = cacheYearOrder.first {
				eventsCache.removeValue(forKey: oldestYear)
				cacheYearOrder.removeFirst()
			}
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
			
			// Add to cache and order list
			eventsCache[year] = events
			cacheYearOrder.append(year)
			
			continuation.resume(returning: events)
		}
	}
    
    // Combine publisher for events
    func eventsPublisher(forYear year: Int) -> AnyPublisher<[EKEvent], EventKitError> {
        return Future<[EKEvent], EventKitError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            Task {
                do {
                    let granted = try await self.requestAccessAsync()
                    if granted {
                        let events = await self.fetchEkEventsAsync(forYear: year)
                        promise(.success(events))
                    } else {
                        promise(.failure(.accessDenied))
                    }
                } catch {
                    promise(.failure(.fetchFailed(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
	
	// Method to clear cache
	func clearCache() {
		eventsCache.removeAll()
		cacheYearOrder.removeAll()
	}
}
