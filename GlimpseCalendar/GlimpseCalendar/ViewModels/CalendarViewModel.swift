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
    
    // Dependencies
    private var eventKitManager: EventKitManager
    private var modelContext: ModelContext
    
    // Cancellables for managing subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init(eventKitManager: EventKitManager, modelContext: ModelContext) {
        self.eventKitManager = eventKitManager
        self.modelContext = modelContext
        self.calendarYear = CalendarFactory.getCalendarYear(for: Date())
        
        // Set up observers
        setupObservers()
    }
    
    private func setupObservers() {
        // Example of how we could observe changes to events in a reactive way
        // This would be implemented when we have a proper Publisher for events
    }
    
    // MARK: - Public Methods
    
    func requestCalendarAccess() {
        eventKitManager.requestAccess(forYear: calendarYear.year)
    }
    
    func syncCalendarWithEventKit(existingEvents: [Event]) {
        // Use a Set for more efficient comparisons
        let existingEventKeys = Set(existingEvents.map { 
            "\($0.name)|\($0.startTime.timeIntervalSince1970)|\($0.endTime.timeIntervalSince1970)" 
        })
        
        for ekEvent in eventKitManager.ekEvents {
            let event = convertToEvent(ekEvent: ekEvent)
            let eventKey = "\(event.name)|\(event.startTime.timeIntervalSince1970)|\(event.endTime.timeIntervalSince1970)"
            
            if !existingEventKeys.contains(eventKey) {
                self.modelContext.insert(event)
            }
        }
        
        do {
            try self.modelContext.save()
            synced = true
        } catch {
            print("Sync failed to save: \(error)")
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
    
    private func convertToEvent(ekEvent: EKEvent) -> Event {
        let event = Event(
            name: ekEvent.title,
            startTime: ekEvent.startDate,
            endTime: ekEvent.endDate,
            location: ekEvent.location ?? "")
        
        return event
    }
}