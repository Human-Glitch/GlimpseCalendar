import XCTest
import EventKit
import Combine
@testable import GlimpseCalendar

// Custom Mock for EKEventStore to avoid using the actual system calendar
class MockEventStore: EKEventStore {
    var events: [EKEvent] = []
    var calendars: [EKCalendar] = []
    var authorizationStatus: EKAuthorizationStatus = .notDetermined
    var testError: Error? = nil
    
    // Important to keep references to all created events
    private var allCreatedEvents: [EKEvent] = []
    
    // Factory method to create events that we keep references to
    func createEvent(title: String, startDate: Date, endDate: Date, calendar: EKCalendar? = nil) -> EKEvent {
        let event = EKEvent(eventStore: self)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = calendar
        
        // Store a strong reference
        allCreatedEvents.append(event)
        return event
    }
    
    // Factory method to create calendars that we keep references to
    func createCalendar(title: String) -> EKCalendar {
        let calendar = EKCalendar(for: .event, eventStore: self)
        calendar.title = title
        return calendar
    }
    
    override func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        // Call on next run loop to simulate async behavior
        DispatchQueue.main.async {
            completion(self.authorizationStatus == .authorized, self.testError)
        }
    }
    
    override func calendars(for entityType: EKEntityType) -> [EKCalendar] {
        return calendars
    }
    
    override func events(matching predicate: NSPredicate) -> [EKEvent] {
        return events
    }
    
    // Support for the modern Events API
    override func requestFullAccessToEvents() async throws -> Bool {
        if let error = testError {
            throw error
        }
        return authorizationStatus == .authorized
    }
    
    // Clear all cached events
	override func reset() {
        events = []
        calendars = []
        allCreatedEvents = []
        testError = nil
        authorizationStatus = .notDetermined
    }
}

final class EventKitManagerTests: XCTestCase {
    var eventKitManager: EventKitManager!
    var mockEventStore: MockEventStore!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockEventStore = MockEventStore()
        eventKitManager = EventKitManager()
        
        // Use our testing method to inject the mock store
        eventKitManager.setEventStoreForTesting(mockEventStore)
    }
    
    override func tearDown() {
        // Reset everything to avoid potential memory issues
        cancellables.removeAll()
        mockEventStore.reset()
        mockEventStore = nil
        eventKitManager = nil
        super.tearDown()
    }
    
    func testRequestAccessAuthorized() {
        // Given
        mockEventStore.authorizationStatus = .authorized
        let expectation = self.expectation(description: "Access request completes")
        var eventsUpdated = false
        
        eventKitManager.$ekEvents
            .dropFirst() // Skip initial empty array
            .sink { _ in
                eventsUpdated = true
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Create mock calendars and events using our factory methods
        let calendar = mockEventStore.createCalendar(title: "Test Calendar")
        mockEventStore.calendars = [calendar]
        
        let event = mockEventStore.createEvent(
            title: "Test Event",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            calendar: calendar
        )
        mockEventStore.events = [event]
        
        // When
        eventKitManager.requestAccess(forYear: 2025)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(eventsUpdated)
        XCTAssertEqual(eventKitManager.ekEvents.count, 1)
        XCTAssertEqual(eventKitManager.ekEvents.first?.title, "Test Event")
        XCTAssertNil(eventKitManager.lastError)
    }
    
    func testRequestAccessDenied() {
        // Given
        mockEventStore.authorizationStatus = .denied
        let expectation = self.expectation(description: "Access request completes with error")
        var receivedError: Error?
        
        eventKitManager.$lastError
            .dropFirst() // Skip initial nil value
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        eventKitManager.requestAccess(forYear: 2025)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is EventKitError)
        XCTAssertEqual((receivedError as? EventKitError), .accessDenied)
        XCTAssertEqual(eventKitManager.ekEvents.count, 0)
    }
    
    func testRequestAccessError() {
        // Given
        mockEventStore.authorizationStatus = .notDetermined
        mockEventStore.testError = NSError(domain: "EventKitError", code: 100, userInfo: nil)
        
        let expectation = self.expectation(description: "Access request completes with error")
        var receivedError: Error?
        
        eventKitManager.$lastError
            .dropFirst() // Skip initial nil value
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        eventKitManager.requestAccess(forYear: 2025)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is EventKitError)
        XCTAssertEqual(eventKitManager.ekEvents.count, 0)
    }
    
    func testFetchEventsForYear() {
        // Given
        mockEventStore.authorizationStatus = .authorized
        let year = 2025
        let calendar = mockEventStore.createCalendar(title: "Test Calendar")
        mockEventStore.calendars = [calendar]
        
        // Create events for different months of the year
        var events: [EKEvent] = []
        
        for month in 1...12 {
            let components = DateComponents(year: year, month: month, day: 15)
            if let date = Calendar.current.date(from: components) {
                let event = mockEventStore.createEvent(
                    title: "Event for month \(month)",
                    startDate: date,
                    endDate: date.addingTimeInterval(3600),
                    calendar: calendar
                )
                events.append(event)
            }
        }
        
        mockEventStore.events = events
        
        // Create expectation for the async operation
        let expectation = self.expectation(description: "Events fetched")
        
        // We need an observer to know when events are updated
        eventKitManager.$ekEvents
            .dropFirst()
            .sink { _ in 
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        // When
        eventKitManager.requestAccess(forYear: year)
        
        // Then
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertEqual(eventKitManager.ekEvents.count, 12)
        
        // Verify events are sorted by startDate
        var previousDate: Date?
        for event in eventKitManager.ekEvents {
            if let previous = previousDate {
                XCTAssertGreaterThanOrEqual(event.startDate, previous, "Events should be sorted by startDate")
            }
            previousDate = event.startDate
        }
    }
}
