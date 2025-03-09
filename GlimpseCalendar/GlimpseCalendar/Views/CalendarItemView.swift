//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI
import SwiftData

struct CalendarItemView: View, Identifiable, Equatable {
	var id: Int { index }
	let weekDay: String
	let date: Date
	let index: Int
	
	@State private var selectedEvent: Event?
	@State private var isPresented = false
	@State private var eventToEdit: Event?
	
	// Remove individual Query subscription
	let events: [Event]
	
	var dayNumber: String {
		return CalendarItemView.dateFormatter.string(from: date)
	}
	
	private static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter
	}()
	
	static func ==(lhs: CalendarItemView, rhs: CalendarItemView) -> Bool {
        return lhs.weekDay == rhs.weekDay && lhs.date == rhs.date && lhs.index == rhs.index
    }
	
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.quaternary)
				.background(.clear)
			
			VStack{
				Spacer(minLength: 30)
				List(fetchEvents(), id: \.self) { event in
					EventCellView(event: event)
						.onTapGesture {
							eventToEdit = event
						}
				}
				.sheet(item: $eventToEdit) { event in
					EditEventView(event: event)
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
						.cornerRadius(5)
						.foregroundStyle(.white)
					
					Spacer()
					
					Button {
						isPresented = true
					} label: {
						Image(systemName: "plus.circle.fill")
							.resizable()
							.scaledToFit()
							.padding(.trailing, 18)
					}
					.sheet(isPresented: $isPresented) {
						AddEventView(startDate: date, endDate: date)
					}
				}
				.frame(height: 30)
				
				Spacer()
			}
			
		}
	}
	
	func fetchEvents() -> [Event] {
		// Use cached date format string for efficiency
		let dateString = date.formattedTime(format: "yyyy-MM-dd")
		return events.filter { dayEvent in
			dayEvent.startTime.formattedTime(format: "yyyy-MM-dd") == dateString
		}
	}
}

// Update the preview to match new parameters
#Preview {
	Group {
		VStack {
			CalendarItemView(weekDay: "MON", date: Date(), index: 0, events: [])
		}
	}
}
