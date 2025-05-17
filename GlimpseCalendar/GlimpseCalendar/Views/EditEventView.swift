//
//  EditEventView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/12/24.
//

import SwiftUI
import SwiftData

struct EditEventView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) private var dismiss
	@StateObject private var viewModel: EventViewModel
	
    // Add completion handlers
    var onEventUpdated: (() -> Void)?
    var onEventDeleted: (() -> Void)?
    
	// Store the event for reinitializing viewModel
	private var event: Event
	
	init(event: Event, onEventUpdated: (() -> Void)? = nil, onEventDeleted: (() -> Void)? = nil) {
		self.event = event
		
		// Create a DataService with a temporary ModelContext
		let container = try! ModelContainer(for: Event.self)
		let context = ModelContext(container)
		let dataService = DataService(modelContext: context)
		
		_viewModel = StateObject(wrappedValue: EventViewModel(
			event: event,
			dataService: dataService
		))
        
        self.onEventUpdated = onEventUpdated
        self.onEventDeleted = onEventDeleted
	}
	
    var body: some View {
		HStack {
			Spacer()
			
			Button {
				viewModel.deleteEvent()
                // Add a very short delay to ensure the data is deleted
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    // Call the completion handler if provided
                    onEventDeleted?()
                    dismiss()
                }
			} label: {
				Image(systemName: "trash")
					.foregroundColor(.red)
					.frame(width: 25, height: 25)
			}
			.frame(width: 25, height: 25)
			.padding()
		}
		
		Form {
			Section(header: Text("Edit Event")) {
				TextField("Name", text: $viewModel.name)
				TextField("Location", text: $viewModel.location)
				DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
				DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
			}
		}
		
		HStack{
			Spacer()
			Button{
				viewModel.updateEvent()
                // Add a very short delay to ensure the data is updated
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    // Call the completion handler if provided
                    onEventUpdated?()
                    dismiss()
                }
			} label: {
				Text("Done")
					.fontWeight(.semibold)
					.padding(10)
			}
			.buttonStyle(BorderedButtonStyle())
			.tint(.blue)
			
			Spacer()
		}
		.task {
			// Update the modelContext instead of trying to reassign viewModel
			viewModel.updateModelContext(modelContext)
		}
    }
}

#Preview {
	EditEventView(event: Event(name: "Test", startTime: Date(), endTime: Date(), location: "Home"))
}
