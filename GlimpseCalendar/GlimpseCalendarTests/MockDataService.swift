import Foundation
import SwiftData
import EventKit
import Combine
@testable import GlimpseCalendar

class MockDataService: DataService {
    var saveEventsCalled = false
    var eventsSaved: Int = 0
    var mockEvents: [Event] = []
    
    override func saveEventsFromEKEvents(_ ekEvents: [EKEvent], existingEvents: [Event]) throws -> Int {
        saveEventsCalled = true
        eventsSaved = ekEvents.count
        return ekEvents.count
    }
    
    override func saveEvent(_ event: Event) throws {
        mockEvents.append(event)
        eventChangedPublisher.send(.added)
    }
    
    override func updateEvent(_ event: Event) throws {
        if let index = mockEvents.firstIndex(where: { $0.id == event.id }) {
            mockEvents[index] = event
        }
        eventChangedPublisher.send(.updated)
    }
    
    override func deleteEvent(_ event: Event) throws {
        mockEvents.removeAll { $0.id == event.id }
        eventChangedPublisher.send(.deleted)
    }
}