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
	
	@Bindable var event: Event
	
    var body: some View {
		HStack {
			Spacer()
			
			Button {
				modelContext.delete(event)
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
			Section(header: Text("Add an Event")) {
				TextField("Name", text: $event.name)
				TextField("Location", text: $event.location)
				DatePicker("Start Date", selection: $event.startTime, displayedComponents: [.date, .hourAndMinute])
				DatePicker("End Date", selection: $event.endTime, displayedComponents: [.date, .hourAndMinute])
			}
		}
		
		HStack{
			Spacer()
			Button{
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
    }
}

#Preview {
	EditEventView(event: Event(name: "Poo", startTime: Date(), endTime: Date(), location: "Home"))
}
