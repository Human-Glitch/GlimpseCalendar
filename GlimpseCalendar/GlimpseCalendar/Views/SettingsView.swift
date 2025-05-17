import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject var eventKitManager: EventKitManager
    @StateObject private var viewModel: SettingsViewModel
    
    init() {
        // Initialize with the passed EventKitManager
        _viewModel = StateObject(wrappedValue: SettingsViewModel(eventKitManager: EventKitManager()))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calendar Sync")) {
                    Toggle("Sync with Apple Calendar", isOn: $viewModel.syncWithAppleCalendar)
                        .onChange(of: viewModel.syncWithAppleCalendar) { newValue in
                            viewModel.toggleAppleCalendarSync(isEnabled: newValue)
                        }
                    
                    if viewModel.syncWithAppleCalendar {
                        Text("Events from Apple Calendar will be imported into Glimpse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Display any errors
                    if let error = viewModel.error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Section(header: Text("About")) {
                    LabeledContent("App Version", value: viewModel.appVersion)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                // Update the EventKitManager to use the one from the environment
                viewModel.updateEventKitManager(eventKitManager)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(EventKitManager())
}
