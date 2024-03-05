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
	
	let calendarItems: [Int: [CalendarItemView]]
	let row: Int
	
	var body: some View {
		ScrollView(.horizontal){
			HStack(alignment: .center) {
				Spacer(minLength: 1)
				
				ForEach(calendarItems[row]!) { calendarItem in
					calendarItem
						.setModifiers(selectedRow: selectedRow, row: row)
						.scrollTransition { content, phase in
							content
								.opacity(phase.isIdentity ? 1 : 0.5)
								.scaleEffect(phase.isIdentity ? 1 : 0.9)
								.blur(radius: phase.isIdentity ? 0 : 5)
						}
						.onTapGesture {
							selectedRow = row
							selectedItem = calendarItem
							selectedItemId = calendarItem.id
						}
					
					Spacer(minLength: 1)
				}
			}
			.scrollTargetLayout()
		}
		.scrollPosition(id: $selectedItemId, anchor: .center)
	}
}

#Preview {
	CalendarRowView(
		selectedItem: .constant(nil),
		selectedItemId: .constant(nil),
		selectedRow: .constant(1),
		calendarItems: MockData.calendarRows,
		row: 1)
}
