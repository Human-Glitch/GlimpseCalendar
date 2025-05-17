import Foundation
import EventKit
import Combine
@testable import GlimpseCalendar

class MockEventKitManager: EventKitManager {
    var requestAccessCalled = false
    var yearRequested: Int?
    var mockEkEvents: [EKEvent] = []
    
    // Need to hold strong references to any EKEvents we create
    private var eventStore = EKEventStore()
    private var createdEvents: [EKEvent] = []
    
    override func requestAccess(forYear year: Int) {
        requestAccessCalled = true
        yearRequested = year
        
        // Simulate an asynchronous response on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.ekEvents = self.mockEkEvents
            self.lastError = nil
        }
    }
    
    // Override the async/await version as well if needed
    override func requestAccessAsync() async throws -> Bool {
        requestAccessCalled = true
        // Add a small delay to simulate real async behavior
        try? await Task.sleep(nanoseconds: 50_000_000)
        return true
    }
    
    override func fetchEkEventsAsync(forYear year: Int) async -> [EKEvent] {
        yearRequested = year
        return mockEkEvents
    }
    
    // Helper method to trigger an error for testing
    func triggerError(_ error: EventKitError) {
        DispatchQueue.main.async { [weak self] in
            self?.lastError = error
        }
    }
    
    // Helper method to create a test event that we maintain a strong reference to
    func createTestEvent(title: String, startDate: Date, endDate: Date) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        // Store a strong reference
        createdEvents.append(event)
        return event
    }
}
