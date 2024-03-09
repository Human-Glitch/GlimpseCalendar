//
//  CalendarRowView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarRowView: View {
	@Binding var selectedItem: CalendarItemView?
	@Binding var selectedItemId: UUID?
	@Binding var selectedRow: Int
	
	var calendarItems: [Int: [CalendarItemView]]
	let row: Int
	
	var body: some View {
		ScrollView(.horizontal){
			HStack(alignment: .center) {
				
				let calendarRowItems = calendarItems[row] ?? []
	
				ForEach(calendarRowItems) { calendarItem in
					
					VStack {
						
						if(row == 1){
							Text(MockData.daysOfWeek[calendarRowItems.firstIndex(of: calendarItem)!])
						}
						
						calendarItem
							.modifier(CustomCalendarRowStyle(selectedRow: selectedRow, row: row))
							.scrollTransition { content, phase in
								content
									.opacity(phase.isIdentity ? 1 : 0.5)
									.scaleEffect(phase.isIdentity ? 1 : 0.95)
									.blur(radius: phase.isIdentity ? 0 : 5)
							}
							.onTapGesture {
								selectedRow = row
								selectedItem = calendarItem
								
								withAnimation(.easeInOut(duration: 0.5)) {
									selectedItemId = calendarItem.id
								}
								
							}
					}
				}
			}
			.scrollTargetLayout()
			
		}
		.scrollDisabled(selectedRow != row)
		.scrollIndicators(.hidden)
		.scrollPosition(id: $selectedItemId, anchor: .center)
		.scrollTargetBehavior(.viewAligned)
	}
}

struct CustomCalendarRowStyle: ViewModifier {
	var selectedRow: Int
	var row: Int
	
	func body(content: Content) -> some View {
		if(selectedRow == row){
			content
				.frame(width: 250, height: 180, alignment: .center)
		}
		else {
			content
				.frame(width: 45, height: 45)
		}
	}
}

#Preview {
	VStack{
		CalendarRowView(
			selectedItem: .constant(nil),
			selectedItemId: .constant(nil),
			selectedRow: .constant(2),
			calendarItems: MockData.calendarRows,
			row: 1)
		.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
		
		CalendarRowView(
			selectedItem: .constant(nil),
			selectedItemId: .constant(nil),
			selectedRow: .constant(2),
			calendarItems: MockData.calendarRows,
			row: 2)
	}
}
