//
//  AddEventView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 5/11/24.
//

import SwiftUI

struct AddEventView: View {
	@Environment(\.modelContext) var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@State private var name: String = ""
	@State private var location: String = ""
	@State var startDate: Date
	@State var endDate: Date

	var body: some View {
		Form {
			Section(header: Text("Add an Event")) {
				TextField("Name", text: $name)
				TextField("Location", text: $location)
				DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
				DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
			}
		}
		
		HStack{
			Spacer()
			Button{
				let event = Event(name: $name.wrappedValue, startTime: $startDate.wrappedValue, endTime: $endDate.wrappedValue, location: $location.wrappedValue)
				
				modelContext.insert(event)
				
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
	}
}

#Preview {
	AddEventView(startDate: .now, endDate: .now)
}
