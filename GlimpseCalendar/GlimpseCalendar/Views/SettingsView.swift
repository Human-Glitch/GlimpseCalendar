import SwiftUI

struct SettingsView: View {
    @State private var syncWithAppleCalendar = false
    @EnvironmentObject var eventKitManager: EventKitManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calendar Sync")) {
                    Toggle("Sync with Apple Calendar", isOn: $syncWithAppleCalendar)
                        .onChange(of: syncWithAppleCalendar) { newValue in
                            // This is where the sync functionality would go in the future
                        }
                    
                    if syncWithAppleCalendar {
                        Text("Events from Apple Calendar will be imported into Glimpse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("About")) {
                    LabeledContent("App Version", value: "1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(EventKitManager())
}
