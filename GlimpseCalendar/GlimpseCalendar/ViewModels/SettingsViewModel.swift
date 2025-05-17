//
//  SettingsViewModel.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    // User settings
    @Published var syncWithAppleCalendar: Bool = false
    @Published var error: Error?
    
    // Dependencies
    private var eventKitManager: EventKitManager
    private var cancellables = Set<AnyCancellable>()
    
    init(eventKitManager: EventKitManager) {
        self.eventKitManager = eventKitManager
        
        // Set up observers for errors
        setupObservers()
    }
    
    // Method to update the EventKitManager after view initialization
    func updateEventKitManager(_ newManager: EventKitManager) {
        self.eventKitManager = newManager
        setupObservers() // Re-setup observers with the new manager
    }
    
    private func setupObservers() {
        // Clean up existing observers
        cancellables.removeAll()
        
        // Observe errors from EventKitManager
        eventKitManager.$lastError
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.error = error
            }
            .store(in: &cancellables)
    }
    
    func toggleAppleCalendarSync(isEnabled: Bool) {
        syncWithAppleCalendar = isEnabled
        
        // Reset any previous errors
        error = nil
        
        if isEnabled {
            // Request calendar access if toggled on
            // This uses the current year
            let currentYear = Calendar.current.component(.year, from: Date())
            eventKitManager.requestAccess(forYear: currentYear)
        } else {
            // Clear the cache when we turn off syncing
            eventKitManager.clearCache()
        }
    }
    
    // App information
    var appVersion: String {
        // Get the app version from the main bundle
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0.0" // Default fallback
    }
}