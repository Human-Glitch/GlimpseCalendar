import XCTest
import SwiftData
import Combine
import EventKit
@testable import GlimpseCalendar

final class DataServiceTests: XCTestCase {
    var dataService: DataService!
    var modelContext: ModelContext!
    var container: ModelContainer!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        // Create an in-memory SwiftData container for testing
        let schema = Schema([Event.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: [configuration])
        modelContext = ModelContext(container)
        
        dataService = DataService(modelContext: modelContext)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        dataService = nil
        modelContext = nil
        container = nil
        super.tearDown()
    }
    
    func testSaveEvent() throws {
        // Given
        let event = Event(
            name: "Test Event",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Test Location"
        )
        
        var receivedChangeType: EventChangeType?
        let expectation = expectation(description: "Event saved notification received")
        
        dataService.eventChangedPublisher
            .sink { changeType in
                receivedChangeType = changeType
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        try dataService.saveEvent(event)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedChangeType, .added)
        
        // Verify the event was actually saved to the context
        let fetchDescriptor = FetchDescriptor<Event>()
        let fetchedEvents = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedEvents.count, 1)
        XCTAssertEqual(fetchedEvents.first?.name, "Test Event")
        XCTAssertEqual(fetchedEvents.first?.location, "Test Location")
    }
    
    func testUpdateEvent() throws {
        // Given
        let event = Event(
            name: "Original Event",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Original Location"
        )
        
        modelContext.insert(event)
        try modelContext.save()
        
        var receivedChangeType: EventChangeType?
        let expectation = expectation(description: "Event updated notification received")
        
        dataService.eventChangedPublisher
            .sink { changeType in
                receivedChangeType = changeType
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        event.name = "Updated Event"
        event.location = "Updated Location"
        try dataService.updateEvent(event)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedChangeType, .updated)
        
        // Verify the event was actually updated in the context
        let fetchDescriptor = FetchDescriptor<Event>()
        let fetchedEvents = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedEvents.count, 1)
        XCTAssertEqual(fetchedEvents.first?.name, "Updated Event")
        XCTAssertEqual(fetchedEvents.first?.location, "Updated Location")
    }
    
    func testDeleteEvent() throws {
        // Given
        let event = Event(
            name: "Event to Delete",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Delete Location"
        )
        
        modelContext.insert(event)
        try modelContext.save()
        
        var receivedChangeType: EventChangeType?
        let expectation = expectation(description: "Event deleted notification received")
        
        dataService.eventChangedPublisher
            .sink { changeType in
                receivedChangeType = changeType
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        try dataService.deleteEvent(event)
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedChangeType, .deleted)
        
        // Verify the event was actually deleted from the context
        let fetchDescriptor = FetchDescriptor<Event>()
        let fetchedEvents = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedEvents.count, 0)
    }
    
    func testSaveEventsFromEKEvents() throws {
        // Given
        let eventStore = EKEventStore()
        let ekEvent1 = EKEvent(eventStore: eventStore)
        ekEvent1.title = "EK Event 1"
        ekEvent1.startDate = Date()
        ekEvent1.endDate = Date().addingTimeInterval(3600)
        ekEvent1.location = "EK Location 1"
        
        let ekEvent2 = EKEvent(eventStore: eventStore)
        ekEvent2.title = "EK Event 2"
        ekEvent2.startDate = Date().addingTimeInterval(7200)
        ekEvent2.endDate = Date().addingTimeInterval(10800)
        ekEvent2.location = "EK Location 2"
        
        let ekEvents = [ekEvent1, ekEvent2]
        
        var receivedChangeType: EventChangeType?
        let expectation = expectation(description: "Events synced notification received")
        
        dataService.eventChangedPublisher
            .sink { changeType in
                receivedChangeType = changeType
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        let savedCount = try dataService.saveEventsFromEKEvents(ekEvents, existingEvents: [])
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(receivedChangeType, .synced)
        XCTAssertEqual(savedCount, 2)
        
        // Verify events were actually saved to the context
        let fetchDescriptor = FetchDescriptor<Event>()
        let fetchedEvents = try modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(fetchedEvents.count, 2)
        
        // Verify the events have the correct data
        let eventNames = Set(fetchedEvents.map { $0.name })
        XCTAssertTrue(eventNames.contains("EK Event 1"))
        XCTAssertTrue(eventNames.contains("EK Event 2"))
        
        let eventLocations = Set(fetchedEvents.map { $0.location })
        XCTAssertTrue(eventLocations.contains("EK Location 1"))
        XCTAssertTrue(eventLocations.contains("EK Location 2"))
    }
    
    func testFetchEvents() throws {
        // Given
        let now = Date()
        
        let event1 = Event(
            name: "Past Event",
            startTime: now.addingTimeInterval(-7200), // 2 hours ago
            endTime: now.addingTimeInterval(-3600),   // 1 hour ago
            location: "Past Location"
        )
        
        let event2 = Event(
            name: "Current Event",
            startTime: now,
            endTime: now.addingTimeInterval(3600),    // 1 hour from now
            location: "Current Location"
        )
        
        let event3 = Event(
            name: "Future Event",
            startTime: now.addingTimeInterval(7200),  // 2 hours from now
            endTime: now.addingTimeInterval(10800),   // 3 hours from now
            location: "Future Location"
        )
        
        modelContext.insert(event1)
        modelContext.insert(event2)
        modelContext.insert(event3)
        try modelContext.save()
        
        // When - fetch with start date filter
        let startDate = now.addingTimeInterval(-1800) // 30 minutes ago
        let futureEvents = try dataService.fetchEvents(startDate: startDate)
        
        // Then
        XCTAssertEqual(futureEvents.count, 2) // Should include Current and Future events
        XCTAssertTrue(futureEvents.contains { $0.name == "Current Event" })
        XCTAssertTrue(futureEvents.contains { $0.name == "Future Event" })
        
        // When - fetch with end date filter
        let endDate = now.addingTimeInterval(1800) // 30 minutes from now
        let pastEvents = try dataService.fetchEvents(endDate: endDate)
        
        // Then
        XCTAssertEqual(pastEvents.count, 2) // Should include Past and Current events
        XCTAssertTrue(pastEvents.contains { $0.name == "Past Event" })
        XCTAssertTrue(pastEvents.contains { $0.name == "Current Event" })
        
        // When - fetch with both start and end date filters
        let rangeEvents = try dataService.fetchEvents(
            startDate: now.addingTimeInterval(-1800), // 30 minutes ago
            endDate: now.addingTimeInterval(1800)     // 30 minutes from now
        )
        
        // Then
        XCTAssertEqual(rangeEvents.count, 1) // Should only include Current event
        XCTAssertEqual(rangeEvents.first?.name, "Current Event")
    }
}