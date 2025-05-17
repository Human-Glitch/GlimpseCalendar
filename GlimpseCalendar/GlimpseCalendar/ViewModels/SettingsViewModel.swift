//
//  SettingsViewModel.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/16/25.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    // User settings
    @Published var syncWithAppleCalendar: Bool = false
    
    // Dependencies
    private var eventKitManager: EventKitManager
    
    init(eventKitManager: EventKitManager) {
        self.eventKitManager = eventKitManager
    }
    
    func toggleAppleCalendarSync(isEnabled: Bool) {
        // This method would implement the actual sync functionality
        // For now it's just setting the published property
        syncWithAppleCalendar = isEnabled
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