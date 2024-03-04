//
//  ContentView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI

struct CalendarView: View {
	@State var selectedRow: Int
	@State var selectedItem: CalendarItemView?
	@State var selectedItemId: UUID?
	
	let calendarItems: [Int: [CalendarItemView]] =
	[
		1:
		[
			CalendarItemView(day: 1),
			CalendarItemView(day: 2),
			CalendarItemView(day: 3),
			CalendarItemView(day: 4),
			CalendarItemView(day: 5),
			CalendarItemView(day: 6),
			CalendarItemView(day: 7)
		],
		2:
		[
			CalendarItemView(day: 8),
			CalendarItemView(day: 9),
			CalendarItemView(day: 10),
			CalendarItemView(day: 11),
			CalendarItemView(day: 12),
			CalendarItemView(day: 13),
			CalendarItemView(day: 14)
		],
		3:
		[
			CalendarItemView(day: 15),
			CalendarItemView(day: 16),
			CalendarItemView(day: 17),
			CalendarItemView(day: 18),
			CalendarItemView(day: 19),
			CalendarItemView(day: 20),
			CalendarItemView(day: 21)
		],
		4:
		[
			CalendarItemView(day: 22),
			CalendarItemView(day: 23),
			CalendarItemView(day: 24),
			CalendarItemView(day: 25),
			CalendarItemView(day: 26),
			CalendarItemView(day: 27),
			CalendarItemView(day: 28)
		]
	]
	
    var body: some View {
		VStack {
			Text("👁️‍🗨️ Glimpse")
				.font(.largeTitle)
				.fontWeight(.semibold)
				.frame(alignment: .top)
				.onTapGesture {
					selectedRow = 0
					selectedItem = nil
					selectedItemId = nil
				}
			
			ScrollView {
				ScrollView(.horizontal){
					HStack(alignment: .center) {
						Spacer(minLength: 15)
						ForEach(calendarItems[1]!) { calendarItem in
							calendarItem
								.setModifiers(selectedRow: selectedRow, row: 1)
								.onTapGesture {
									selectedRow = 1
									selectedItem = calendarItem
									selectedItemId = calendarItem.id
								}
						}
						Spacer(minLength: 10)
					}
					.scrollTargetLayout()
				}
				.scrollPosition(id: $selectedItemId, anchor: .center)
				
				ScrollView(.horizontal){
					HStack(alignment: .center) {
						Spacer(minLength: 15)
						ForEach(calendarItems[2]!) { calendarItem in
							calendarItem
								.setModifiers(selectedRow: selectedRow, row: 2)
								.onTapGesture {
									selectedRow = 2
									selectedItem = calendarItem
									selectedItemId = calendarItem.id
								}
						}
						Spacer(minLength: 10)
					}
					.scrollTargetLayout()
				}
				.scrollPosition(id: $selectedItemId, anchor: .center)
				
				ScrollView(.horizontal){
					HStack(alignment: .center) {
						Spacer(minLength: 15)
						ForEach(calendarItems[3]!) { calendarItem in
							calendarItem
								.setModifiers(selectedRow: selectedRow, row: 3)
								.onTapGesture {
									selectedRow = 3
									selectedItem = calendarItem
									selectedItemId = calendarItem.id
								}
						}
						Spacer(minLength: 10)
					}
					.scrollTargetLayout()
				}
				.scrollPosition(id: $selectedItemId, anchor: .center)
				
				ScrollView(.horizontal){
					HStack(alignment: .center) {
						Spacer(minLength: 15)
						ForEach(calendarItems[4]!) { calendarItem in
							calendarItem
								.setModifiers(selectedRow: selectedRow, row: 4)
								.onTapGesture {
									selectedRow = 4
									selectedItem = calendarItem
									selectedItemId = calendarItem.id
								}
						}
						Spacer(minLength: 10)
					}
					.scrollTargetLayout()
				}
				.scrollPosition(id: $selectedItemId, anchor: .center)
			}
			
			if(selectedItem != nil) {
				List() {
					ForEach(selectedItem!.events, id: \.self){ event in
						Text(event)
					}
				}
				.frame(height: 250)
			}
		}
		
	}
}

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let day: Int
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		Rectangle()
			.overlay {
				Text("\(day)")
					.foregroundStyle(.white)
					.multilineTextAlignment(.center)
			}
	}
	
	func setModifiers(selectedRow: Int, row: Int) -> some View {
		
		if(selectedRow == row){
			return self
				.frame(width: 300, height: 200, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 10, y: 5)
		}
		else {
			return self
				.frame(width: 45, height: 45)
				.clipShape(RoundedRectangle(cornerRadius: 5))
				.shadow(radius: 10, y: 5)
		}
		
	}
}

#Preview {
	CalendarView(selectedRow: 0)
}
