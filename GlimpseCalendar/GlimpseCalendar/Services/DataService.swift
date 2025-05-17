//
//  DataService.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftData
import Combine
import EventKit

enum EventChangeType {
    case added
    case updated
    case deleted
    case synced
}

class DataService {
    private let modelContext: ModelContext
    
    // Event notification publishers - using a more specific event type
    let eventChangedPublisher = PassthroughSubject<EventChangeType, Never>()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Event Operations
    
    func saveEvent(_ event: Event) throws {
        modelContext.insert(event)
        try modelContext.save()
        // Publish event change notification with specific type
        eventChangedPublisher.send(.added)
    }
    
    func updateEvent(_ event: Event) throws {
        try modelContext.save()
        // Publish event change notification with specific type
        eventChangedPublisher.send(.updated)
    }
    
    func deleteEvent(_ event: Event) throws {
        modelContext.delete(event)
        try modelContext.save()
        // Publish event change notification with specific type
        eventChangedPublisher.send(.deleted)
    }
    
    func fetchEvents(startDate: Date? = nil, endDate: Date? = nil) throws -> [Event] {
        var descriptor = FetchDescriptor<Event>(sortBy: [SortDescriptor(\.startTime)])
        
        if let startDate = startDate, let endDate = endDate {
            descriptor.predicate = #Predicate<Event> { 
                $0.startTime >= startDate && $0.startTime <= endDate 
            }
        } else if let startDate = startDate {
            descriptor.predicate = #Predicate<Event> { $0.startTime >= startDate }
        } else if let endDate = endDate {
            descriptor.predicate = #Predicate<Event> { $0.startTime <= endDate }
        }
        
        return try modelContext.fetch(descriptor)
    }
    
    // MARK: - Event Synchronization
    
    func saveEventsFromEKEvents(_ ekEvents: [EKEvent], existingEvents: [Event]) throws -> Int {
        // Use a Set for more efficient comparisons
        let existingEventKeys = Set(existingEvents.map { 
            "\($0.name)|\($0.startTime.timeIntervalSince1970)|\($0.endTime.timeIntervalSince1970)" 
        })
        
        var savedCount = 0
        
        for ekEvent in ekEvents {
            let event = Event(
                name: ekEvent.title,
                startTime: ekEvent.startDate,
                endTime: ekEvent.endDate,
                location: ekEvent.location ?? ""
            )
            
            let eventKey = "\(event.name)|\(event.startTime.timeIntervalSince1970)|\(event.endTime.timeIntervalSince1970)"
            
            if !existingEventKeys.contains(eventKey) {
                modelContext.insert(event)
                savedCount += 1
            }
        }
        
        try modelContext.save()
        
        // Notify only if events were actually saved
        if savedCount > 0 {
            eventChangedPublisher.send(.synced)
        }
        
        return savedCount
    }
}