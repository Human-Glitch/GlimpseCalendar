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
	
	// Store the event for reinitializing viewModel
	private var event: Event
	
	init(event: Event) {
		self.event = event
		// Initialize with dummy model context, will replace using updateModelContext
		_viewModel = StateObject(wrappedValue: EventViewModel(
			event: event,
			modelContext: ModelContext(try! ModelContainer(for: Event.self))
		))
	}
	
    var body: some View {
		HStack {
			Spacer()
			
			Button {
				viewModel.deleteEvent()
				dismiss()
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
				dismiss()
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
