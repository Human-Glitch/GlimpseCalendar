//
//  EventViewModel.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

class EventViewModel: ObservableObject {
    // Properties for creating/editing an event
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var startDate: Date
    @Published var endDate: Date
    @Published var error: Error?
    @Published var isSaving: Bool = false
    @Published var isDeleting: Bool = false
    
    // For editing an existing event
    var existingEvent: Event?
    
    // Service dependencies
    private var dataService: DataService
    
    // Initialize for creating a new event
    init(startDate: Date, endDate: Date, dataService: DataService) {
        self.startDate = startDate
        self.endDate = endDate
        self.dataService = dataService
    }
    
    // Initialize for editing an existing event
    init(event: Event, dataService: DataService) {
        self.existingEvent = event
        self.name = event.name
        self.location = event.location
        self.startDate = event.startTime
        self.endDate = event.endTime
        self.dataService = dataService
    }
    
    // Method to update model context after view initialization
    func updateModelContext(_ newContext: ModelContext) {
        self.dataService = DataService(modelContext: newContext)
    }
    
    // Save a new event with improved feedback
    func saveNewEvent() {
        isSaving = true
        
        let event = Event(
            name: name,
            startTime: startDate,
            endTime: endDate,
            location: location
        )
        
        do {
            try dataService.saveEvent(event)
            error = nil
            
            // Force UI to update immediately 
            DispatchQueue.main.async {
                self.isSaving = false
                // The event publisher in DataService will handle UI refreshes
            }
        } catch {
            self.error = error
            print("Failed to save new event: \(error)")
            isSaving = false
        }
    }
    
    // Update an existing event
    func updateEvent() {
        guard let event = existingEvent else { return }
        isSaving = true
        
        event.name = name
        event.location = location
        event.startTime = startDate
        event.endTime = endDate
        
        do {
            try dataService.updateEvent(event)
            error = nil
            
            // Force UI to update immediately
            DispatchQueue.main.async {
                self.isSaving = false
                // The event publisher in DataService will handle UI refreshes
            }
        } catch {
            self.error = error
            print("Failed to update event: \(error)")
            isSaving = false
        }
    }
    
    // Delete an event with improved feedback
    func deleteEvent() {
        guard let event = existingEvent else { return }
        isDeleting = true
        
        do {
            try dataService.deleteEvent(event)
            error = nil
            
            // Force UI to update immediately
            DispatchQueue.main.async {
                self.isDeleting = false
                // The event publisher in DataService will handle UI refreshes
            }
        } catch {
            self.error = error
            print("Failed to delete event: \(error)")
            isDeleting = false
        }
    }
}