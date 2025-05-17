//
//  AddEventView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/11/24.
//

import SwiftUI
import SwiftData

struct AddEventView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) private var dismiss
	@StateObject private var viewModel: EventViewModel
    
    // Add a completion handler
    var onEventAdded: (() -> Void)?
	
	init(startDate: Date, endDate: Date, onEventAdded: (() -> Void)? = nil) {
		// Create a DataService with a temporary ModelContext
		let container = try! ModelContainer(for: Event.self)
		let context = ModelContext(container)
		let dataService = DataService(modelContext: context)
		
		_viewModel = StateObject(wrappedValue: EventViewModel(
			startDate: startDate,
			endDate: endDate,
			dataService: dataService
		))
        
        self.onEventAdded = onEventAdded
	}

	var body: some View {
		Form {
			Section(header: Text("Add an Event")) {
				TextField("Name", text: $viewModel.name)
				TextField("Location", text: $viewModel.location)
				DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
				DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
			}
		}
		
		HStack{
			Spacer()
			Button{
				viewModel.saveNewEvent()
                // Add a very short delay to ensure the data is saved
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    // Call the completion handler if provided
                    onEventAdded?()
                    dismiss()
                }
			} label: {
				Text("Save Changes")
					.fontWeight(.semibold)
					.padding(10)
			}
			.buttonStyle(BorderedButtonStyle())
			.tint(.blue)
			
			Spacer()
		}
		.task {
			// Instead of trying to reassign viewModel in onAppear,
			// we'll make sure modelContext is correctly used when saving
			viewModel.updateModelContext(modelContext)
		}
	}
}

#Preview {
	AddEventView(startDate: .now, endDate: .now)
}
