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
		VStack{
			HStack{
				VStack{
					Text(event.startTime.formattedTime())
					Text(event.endTime.formattedTime())
				}
				.frame(width: 60, alignment: .trailing)
				.padding(5)
				.foregroundColor(.white)
				.background(.gray)
				.cornerRadius(10)
				
				VStack{
					HStack{
						Label(event.name, systemImage: "calendar")
							.lineLimit(1)
							.padding(.trailing)
							.scaledToFit()
							.minimumScaleFactor(0.8)
						
						Spacer()
					}
					
					HStack{
						Label("Home", systemImage: "mappin.and.ellipse")
							.bold()
						
						Spacer()
					}
				}
			}
			.font(.footnote)
		}
    }
}

struct Event: Hashable {
	init(name: String,
		startTime: Date,
		endTime: Date,
		location: String) {
		self.name = name
		self.startTime = startTime
		self.endTime = endTime
		self.location = location
	}
	
	var name: String
	var startTime: Date
	var endTime: Date
	var location: String
}

extension Date {
	func formattedTime(format: String = "h:mm a") -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}

#Preview {
	EventCellView(event: Event(name: "Blah", startTime: Date(), endTime: Date(), location: "Home"))
}
