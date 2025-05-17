//
//  EventCellView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/28/24.
//

import SwiftUI

struct EventCellView: View {
	var event: Event

    var body: some View {
		// Removed the outer VStack and nested HStacks
		HStack {
			VStack(alignment: .trailing, spacing: 2) {
				Text(event.startTime.formattedTime())
				Text(event.endTime.formattedTime())
			}
			.frame(width: 55)
			.padding(5)
			.font(.caption2)
			.foregroundColor(.white)
			.background(Color.gray)
			.cornerRadius(10)
			
			VStack(alignment: .leading, spacing: 4) {
				Label(event.name, systemImage: "calendar")
					.lineLimit(1)
					.minimumScaleFactor(0.8)
				Label(event.location.isEmpty ? "No location" : event.location, systemImage: "mappin.and.ellipse")
					.bold()
                    .lineLimit(1)
					.minimumScaleFactor(0.8)
			}
		}
		.font(.caption)
    }
}

#Preview {
	EventCellView(event: Event(name: "Blah", startTime: Date(), endTime: Date(), location: "Home"))
}
