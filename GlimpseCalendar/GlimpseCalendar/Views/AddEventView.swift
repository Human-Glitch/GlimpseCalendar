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
	
	init(startDate: Date, endDate: Date) {
		// Initialize with default values that will be used throughout
		_viewModel = StateObject(wrappedValue: EventViewModel(
			startDate: startDate,
			endDate: endDate,
			modelContext: ModelContext(try! ModelContainer(for: Event.self))
		))
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
				dismiss()
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
