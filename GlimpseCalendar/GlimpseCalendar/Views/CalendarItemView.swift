//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let day: String
	let index: Int
	
	var events: [Event] = [
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		Event(
			name: "Blah",
			startTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
			endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
			location: "Home"),
		
	]
	
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.quaternary)
				.background(.clear)
			
			VStack{
				Spacer(minLength: 30)
				List(events, id: \.self) { event in
					EventCellView(event: event)
				}
				.listStyle(.plain)
				.font(.footnote)
				.fontWeight(.semibold)
			}
			
			VStack{
				HStack (spacing: 0){
					Text(day)
						.frame(width: 50, height: 20)
						.font(.title2)
						.fontDesign(.monospaced)
						.fontWeight(.bold)
						.background(.white)
						.cornerRadius(5)
						.padding(.leading, 25)
					
					Text("\(index + 1)")
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
}

#Preview {
	Group {
		VStack {
			CalendarItemView(day: "MON", index: 0)
		}
	}
}
