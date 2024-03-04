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
	
	let calendarRows: [Int: [CalendarItemView]] =
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
		],
		5:
		[
			CalendarItemView(day: 29),
			CalendarItemView(day: 30),
			CalendarItemView(day: 31)
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
			
			ForEach(calendarRows.sorted(by: { $0.0 < $1.0 }), id: \.0) { calendarRow in
				CalendarRowView(
					selectedItem: $selectedItem,
					selectedItemId: $selectedItemId,
					selectedRow: $selectedRow,
					calendarItems: calendarRows,
					row: calendarRow.key)
			}
			
			Spacer()
			
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

struct CalendarRowView: View {
	@Binding var selectedItem: CalendarItemView?
	@Binding var selectedItemId: UUID?
	@Binding var selectedRow: Int
	
	let calendarItems: [Int: [CalendarItemView]]
	let row: Int
	
	
	var body: some View {
		ScrollView(.horizontal){
			HStack(alignment: .center) {
				Spacer(minLength: 15)
				ForEach(calendarItems[row]!) { calendarItem in
					calendarItem
						.setModifiers(selectedRow: selectedRow, row: row)
						.onTapGesture {
							selectedRow = row
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
}

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let day: Int
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		Rectangle()
			.overlay {
				Text("\(day)")
					.foregroundStyle(.gray)
			}
	}
	
	func setModifiers(selectedRow: Int, row: Int) -> some View {
		
		if(selectedRow == row){
			return self
				.frame(width: 300, height: 200, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 5)
				.padding(5)
		}
		else {
			return self
				.frame(width: 45, height: 45)
				.clipShape(RoundedRectangle(cornerRadius: 5))
				.shadow(radius: 5)
				.padding(5)
		}
		
	}
}

#Preview {
	CalendarView(selectedRow: 0)
}
