//
//  EventViewModel.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftUI
import SwiftData

class EventViewModel: ObservableObject {
    // Properties for creating a new event
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var startDate: Date
    @Published var endDate: Date
    
    // For editing an existing event
    var existingEvent: Event?
    private var modelContext: ModelContext
    
    // Initialize for creating a new event
    init(startDate: Date, endDate: Date, modelContext: ModelContext) {
        self.startDate = startDate
        self.endDate = endDate
        self.modelContext = modelContext
    }
    
    // Initialize for editing an existing event
    init(event: Event, modelContext: ModelContext) {
        self.existingEvent = event
        self.name = event.name
        self.location = event.location
        self.startDate = event.startTime
        self.endDate = event.endTime
        self.modelContext = modelContext
    }
    
    // Method to update model context after view initialization
    func updateModelContext(_ newContext: ModelContext) {
        self.modelContext = newContext
    }
    
    // Save a new event
    func saveNewEvent() {
        let event = Event(
            name: name,
            startTime: startDate,
            endTime: endDate,
            location: location
        )
        
        modelContext.insert(event)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save new event: \(error)")
        }
    }
    
    // Update an existing event
    func updateEvent() {
        guard let event = existingEvent else { return }
        
        event.name = name
        event.location = location
        event.startTime = startDate
        event.endTime = endDate
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to update event: \(error)")
        }
    }
    
    // Delete an event
    func deleteEvent() {
        guard let event = existingEvent else { return }
        
        modelContext.delete(event)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete event: \(error)")
        }
    }
}