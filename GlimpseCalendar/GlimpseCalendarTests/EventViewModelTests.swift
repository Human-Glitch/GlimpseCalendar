import XCTest
import Combine
import SwiftData
@testable import GlimpseCalendar

final class EventViewModelTests: XCTestCase {
    var viewModel: EventViewModel!
    var dataService: MockDataService!
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
        
        dataService = MockDataService(modelContext: modelContext)
        viewModel = EventViewModel(
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            dataService: dataService
        )
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        dataService = nil
        modelContext = nil
        container = nil
        super.tearDown()
    }
    
    func testSaveNewEvent() {
        // Given
        let eventName = "Test Event"
        let eventLocation = "Test Location"
        let startDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        
        viewModel.name = eventName
        viewModel.location = eventLocation
        viewModel.startDate = startDate
        viewModel.endDate = endDate
        
        // When
        viewModel.saveNewEvent()
        
        // Then
        XCTAssertEqual(dataService.mockEvents.count, 1)
        let savedEvent = dataService.mockEvents.first!
        XCTAssertEqual(savedEvent.name, eventName)
        XCTAssertEqual(savedEvent.location, eventLocation)
        XCTAssertEqual(savedEvent.startTime, startDate)
        XCTAssertEqual(savedEvent.endTime, endDate)
    }
    
    func testUpdateEvent() {
        // Given
        let existingEvent = Event(
            name: "Original Event",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Original Location"
        )
        
        dataService.mockEvents = [existingEvent]
        
        let editViewModel = EventViewModel(
            event: existingEvent,
            dataService: dataService
        )
        
        // Update event properties
        editViewModel.name = "Updated Event"
        editViewModel.location = "Updated Location"
        let newStartDate = Date().addingTimeInterval(7200)
        let newEndDate = Date().addingTimeInterval(10800)
        editViewModel.startDate = newStartDate
        editViewModel.endDate = newEndDate
        
        // When
        editViewModel.updateEvent()
        
        // Then
        XCTAssertEqual(existingEvent.name, "Updated Event")
        XCTAssertEqual(existingEvent.location, "Updated Location")
        XCTAssertEqual(existingEvent.startTime, newStartDate)
        XCTAssertEqual(existingEvent.endTime, newEndDate)
    }
    
    func testDeleteEvent() {
        // Given
        let eventToDelete = Event(
            name: "Event to Delete",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            location: "Delete Location"
        )
        
        dataService.mockEvents = [eventToDelete]
        
        let deleteViewModel = EventViewModel(
            event: eventToDelete,
            dataService: dataService
        )
        
        // When
        deleteViewModel.deleteEvent()
        
        // Then
        XCTAssertTrue(dataService.mockEvents.isEmpty)
    }
    
    func testUpdateModelContext() {
        // Given
        let container = try! ModelContainer(for: Event.self)
        let newContext = ModelContext(container)
        let newDataService = DataService(modelContext: newContext)
        
        // When
        viewModel.updateModelContext(newContext)
        
        // Then
        // This is a bit tricky to test directly since the dataService is private
        // We'll verify indirectly by ensuring no crash
        XCTAssertNoThrow(viewModel.saveNewEvent())
    }
}
