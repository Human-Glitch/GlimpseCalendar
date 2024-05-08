//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI
import SwiftData

struct CalendarItemView: View, Identifiable {
	let id = UUID()
	let weekDay: String
	let date: Date
	let index: Int
	
	@State private var selectedEvent: Event?
	
	@Query(sort: \Event.startTime)
	private var events: [Event]
	
	var dayNumber: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"

		return formatter.string(from: date)
	}
	
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.quaternary)
				.background(.clear)
			
			VStack{
				Spacer(minLength: 30)
				List(fetchEvents(events: events), id: \.self) { event in
					EventCellView(event: event)
				}
				.listStyle(.plain)
				.font(.footnote)
				.fontWeight(.semibold)
			}
			
			VStack{
				HStack (spacing: 0){
					Text("\(weekDay)")
						.frame(width: 50, height: 20)
						.font(.title2)
						.fontDesign(.monospaced)
						.fontWeight(.bold)
						.background(.white)
						.cornerRadius(5)
						.padding(.leading, 18)
					
					Text("\(dayNumber)")
						.frame(width: 25, height: 25, alignment: .center)
						.font(.title3)
						.fontDesign(.monospaced)
						.fontWeight(.bold)
						.background(.red.opacity(0.8))
						.cornerRadius(10)
						.foregroundStyle(.white)
						.padding(.leading, 22)
					
					Spacer()
				}
				.frame(height: 30)
				
				Spacer()
			}
			
		}
	}
	
	func fetchEvents(events: [Event]) -> [Event] {
		let dayEvents = events.filter { dayEvent in
			dayEvent.startTime.formattedTime(format: "yyyy-MM-dd") == date.formattedTime(format: "yyyy-MM-dd")
		}
		
		return dayEvents
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(weekDay: "MON", date: Date(), index: 0)
		}
	}
}
