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
				.frame(width: 55, alignment: .trailing)
				.padding(5)
				.font(.caption2)
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
			.font(.caption)
		}
    }
}

#Preview {
	EventCellView(event: Event(name: "Blah", startTime: Date(), endTime: Date(), location: "Home"))
}
