import XCTest
import Combine
import SwiftData
import EventKit
@testable import GlimpseCalendar

final class CalendarViewModelTests: XCTestCase {
    var viewModel: CalendarViewModel!
    var eventKitManager: MockEventKitManager!
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
        
        eventKitManager = MockEventKitManager()
        dataService = MockDataService(modelContext: modelContext)
        viewModel = CalendarViewModel(eventKitManager: eventKitManager, dataService: dataService)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        dataService = nil
        eventKitManager = nil
        modelContext = nil
        container = nil
        super.tearDown()
    }
    
    func testRequestCalendarAccess() {
        // When
        viewModel.requestCalendarAccess()
        
        // Then
        XCTAssertTrue(eventKitManager.requestAccessCalled)
        XCTAssertEqual(eventKitManager.yearRequested, viewModel.calendarYear.year)
    }
    
    func testSyncCalendarWithEventKit() {
        // Given
        let existingEvents: [Event] = []
        let mockEkEvent = EKEvent(eventStore: EKEventStore())
        mockEkEvent.title = "Test Event"
        mockEkEvent.startDate = Date()
        mockEkEvent.endDate = Date().addingTimeInterval(3600) // 1 hour later
        eventKitManager.mockEkEvents = [mockEkEvent]
        eventKitManager.ekEvents = [mockEkEvent] // Set manually since we're not calling requestAccess
        
        // When
        viewModel.syncCalendarWithEventKit(existingEvents: existingEvents)
        
        // Then
        XCTAssertTrue(dataService.saveEventsCalled)
        XCTAssertEqual(dataService.eventsSaved, 1)
        XCTAssertTrue(viewModel.synced)
    }
    
    func testGoToToday() {
        // Given
        let originalDate = viewModel.selectedMonth
        let calendar = Calendar.current
        
        // Modify selectedMonth to something other than today
        viewModel.selectedMonth = calendar.date(byAdding: .month, value: -2, to: originalDate)!
        viewModel.selectedRow = 2
        viewModel.selectedItemID = 3
        viewModel.selectedIndex = 4
        
        // When
        viewModel.goToToday()
        
        // Then
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let selectedMonthComponents = calendar.dateComponents([.year, .month, .day], from: viewModel.selectedMonth)
        
        XCTAssertEqual(todayComponents.year, selectedMonthComponents.year)
        XCTAssertEqual(todayComponents.month, selectedMonthComponents.month)
        XCTAssertEqual(viewModel.selectedRow, -1)
        XCTAssertNil(viewModel.selectedItemID)
        XCTAssertEqual(viewModel.selectedIndex, 0)
    }
    
    func testGoToPreviousMonth() {
        // Given
        let originalDate = viewModel.selectedMonth
        let calendar = Calendar.current
        
        // When
        viewModel.goToPreviousMonth()
        
        // Then
        let expectedDate = calendar.date(byAdding: .month, value: -1, to: originalDate)!
        let expectedComponents = calendar.dateComponents([.year, .month], from: expectedDate)
        let actualComponents = calendar.dateComponents([.year, .month], from: viewModel.selectedMonth)
        
        XCTAssertEqual(expectedComponents.year, actualComponents.year)
        XCTAssertEqual(expectedComponents.month, actualComponents.month)
        XCTAssertEqual(viewModel.selectedRow, -1)
        XCTAssertNil(viewModel.selectedItemID)
        XCTAssertEqual(viewModel.selectedIndex, 0)
    }
    
    func testGoToNextMonth() {
        // Given
        let originalDate = viewModel.selectedMonth
        let calendar = Calendar.current
        
        // When
        viewModel.goToNextMonth()
        
        // Then
        let expectedDate = calendar.date(byAdding: .month, value: 1, to: originalDate)!
        let expectedComponents = calendar.dateComponents([.year, .month], from: expectedDate)
        let actualComponents = calendar.dateComponents([.year, .month], from: viewModel.selectedMonth)
        
        XCTAssertEqual(expectedComponents.year, actualComponents.year)
        XCTAssertEqual(expectedComponents.month, actualComponents.month)
        XCTAssertEqual(viewModel.selectedRow, -1)
        XCTAssertNil(viewModel.selectedItemID)
        XCTAssertEqual(viewModel.selectedIndex, 0)
    }
}
