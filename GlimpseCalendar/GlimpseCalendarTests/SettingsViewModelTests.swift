import XCTest
import Combine
@testable import GlimpseCalendar

final class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModel!
    var eventKitManager: MockEventKitManager!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        eventKitManager = MockEventKitManager()
        viewModel = SettingsViewModel(eventKitManager: eventKitManager)
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        eventKitManager = nil
        super.tearDown()
    }
    
    func testToggleAppleCalendarSyncOn() {
        // Given
        XCTAssertFalse(viewModel.syncWithAppleCalendar)
        
        // When
        viewModel.toggleAppleCalendarSync(isEnabled: true)
        
        // Then
        XCTAssertTrue(viewModel.syncWithAppleCalendar)
        XCTAssertTrue(eventKitManager.requestAccessCalled)
        XCTAssertEqual(eventKitManager.yearRequested, Calendar.current.component(.year, from: Date()))
    }
    
    func testToggleAppleCalendarSyncOff() {
        // Given
        viewModel.syncWithAppleCalendar = true
        
        // When
        viewModel.toggleAppleCalendarSync(isEnabled: false)
        
        // Then
        XCTAssertFalse(viewModel.syncWithAppleCalendar)
    }
    
    func testUpdateEventKitManager() {
        // Given
        let newEventKitManager = MockEventKitManager()
        
        // When
        viewModel.updateEventKitManager(newEventKitManager)
        
        // Then - Verify the new manager is used by triggering a function that uses it
        viewModel.toggleAppleCalendarSync(isEnabled: true)
        XCTAssertTrue(newEventKitManager.requestAccessCalled)
        XCTAssertFalse(eventKitManager.requestAccessCalled) // Original manager not called
    }
    
    func testAppVersion() {
        // This test verifies that app version is returned
        // Since we can't easily mock Bundle.main.infoDictionary, we just check it's not empty
        XCTAssertFalse(viewModel.appVersion.isEmpty)
    }
    
    func testErrorPropagation() {
        // Given
        let expectation = expectation(description: "Error should propagate to view model")
        var receivedError: Error? = nil
        
        viewModel.$error
            .dropFirst() // Skip initial nil value
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When - simulate an error from EventKitManager
        eventKitManager.lastError = EventKitError.accessDenied
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertTrue(receivedError is EventKitError)
    }
}