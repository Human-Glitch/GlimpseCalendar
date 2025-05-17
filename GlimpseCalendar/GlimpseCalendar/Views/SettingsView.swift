import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var eventKitManager: EventKitManager
    @StateObject private var viewModel: SettingsViewModel
    
    init() {
        // Initialize the view model with a temporary EventKitManager
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
                }
                
                Section(header: Text("About")) {
                    LabeledContent("App Version", value: viewModel.appVersion)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                // We can't reassign the StateObject, so we'll use the environmentObject directly
                viewModel.toggleAppleCalendarSync(isEnabled: viewModel.syncWithAppleCalendar)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(EventKitManager())
}
