//
//  CalendarViewModel.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine
import EventKit

class CalendarViewModel: ObservableObject {
    // Published properties for UI binding
    @Published var selectedRow: Int = -1
    @Published var selectedItemID: Int? = nil
    @Published var selectedIndex: Int = 0
    @Published var selectedMonth: Date = Date()
    @Published var synced: Bool = false
    @Published var showSettings: Bool = false
    @Published var calendarYear: CalendarYear
    @Published var error: Error?
    
    // Dependencies
    private var eventKitManager: EventKitManager
    let dataService: DataService
    
    // Cancellables for managing subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init(eventKitManager: EventKitManager, dataService: DataService) {
        self.eventKitManager = eventKitManager
        self.dataService = dataService
        self.calendarYear = CalendarFactory.getCalendarYear(for: Date())
        
        // Set up observers
        setupObservers()
    }
    
    private func setupObservers() {
        // Observe EventKitManager errors
        eventKitManager.$lastError
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.error = error
            }
            .store(in: &cancellables)
            
        // Subscribe to event changes from DataService
        dataService.eventChangedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                // Refresh UI state by updating the month
                // This will trigger a rebuild of the calendar views
                if let currentMonth = self?.selectedMonth {
                    self?.selectedMonth = currentMonth
                    
                    // This is a small delay to ensure the change happens after
                    // the view dismisses any modal sheets
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func requestCalendarAccess() {
        eventKitManager.requestAccess(forYear: calendarYear.year)
    }
    
    func syncCalendarWithEventKit(existingEvents: [Event]) {
        do {
            let savedCount = try dataService.saveEventsFromEKEvents(
                eventKitManager.ekEvents,
                existingEvents: existingEvents
            )
            
            if savedCount > 0 {
                print("Synced \(savedCount) new events")
            }
            
            synced = true
            error = nil
        } catch {
            self.error = error
            print("Sync failed: \(error)")
        }
    }
    
    func buildCalendarByMonth(existingEvents: [Event]) -> [AnyView] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedMonth)
        
        var views: [AnyView] = []
        for calendarWeek in calendarYear.calendarMonths[month - 1].calendarWeeks {
            
            if calendarWeek.weekNumber == selectedRow {
                let view = AnyView(
                    ActiveCalendarRowCarouselView(
                        selectedItemID: Binding<Int?>(
                            get: { self.selectedItemID },
                            set: { self.selectedItemID = $0 }
                        ),
                        selectedRow: Binding<Int>(
                            get: { self.selectedRow },
                            set: { self.selectedRow = $0 }
                        ),
                        selectedIndex: Binding<Int>(
                            get: { self.selectedIndex },
                            set: { self.selectedIndex = $0 }
                        ),
                        calendarDays: calendarWeek.calendarDays,
                        row: calendarWeek.weekNumber,
                        events: existingEvents)
                )
                views.append(view)
            } else {
                let view = AnyView(
                    InactiveCalendarRowCarouselView(
                        selectedRow: Binding<Int>(
                            get: { self.selectedRow },
                            set: { self.selectedRow = $0 }
                        ),
                        selectedIndex: Binding<Int>(
                            get: { self.selectedIndex },
                            set: { self.selectedIndex = $0 }
                        ),
                        calendarDays: .constant(calendarWeek.calendarDays),
                        row: calendarWeek.weekNumber)
                )
                views.append(view)
            }
        }
        
        return views
    }
    
    func clearState() {
        selectedRow = -1
        selectedItemID = nil
        selectedIndex = 0
    }
    
    func goToToday() {
        selectedMonth = Date()
        clearState()
    }
    
    func goToPreviousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth)!
        clearState()
    }
    
    func goToNextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth)!
        clearState()
    }
    
    // MARK: - Helper Methods
    
    private func getEventsForMonth() {
        // This method could be used to filter events for the current month view
        let calendar = Calendar.current
        let month = calendar.component(.month, from: selectedMonth)
        let year = calendar.component(.year, from: selectedMonth)
        
        var startComponents = DateComponents()
        startComponents.year = year
        startComponents.month = month
        startComponents.day = 1
        
        var endComponents = DateComponents()
        endComponents.year = year
        endComponents.month = month + 1
        endComponents.day = 1
        
        guard let startDate = calendar.date(from: startComponents),
              let endDate = calendar.date(from: endComponents) else {
            return
        }
        
        // The actual fetching would happen here, using DataService
        // but we're currently relying on the @Query in the view
    }
}