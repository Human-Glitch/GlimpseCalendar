//
//  ContentView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI

struct CalendarView: View {
	@State var selectedRow = 0
	@State var selectedItem: CalendarItemView?
	@State var selectedItemId: UUID?
	
    var body: some View {
		VStack(alignment: .center){
			Text("👁️‍🗨️ Glimpse")
				.font(.largeTitle)
				.fontWeight(.semibold)
				.frame(alignment: .top)
				.onTapGesture {
					selectedRow = 0
					selectedItem = nil
					selectedItemId = nil
				}
			
			ForEach(MockData.calendarRows.sorted(by: { $0.0 < $1.0 }), id: \.0) { calendarRow in
				
				CalendarRowView(
					selectedItem: $selectedItem,
					selectedItemId: $selectedItemId,
					selectedRow: $selectedRow,
					calendarItems: MockData.calendarRows,
					row: calendarRow.key)
			}
			
			Spacer()
			
			if(selectedRow != 0) {
				List() {
					ForEach(selectedItem!.events, id: \.self){ event in
						Text(event)
					}
				}
				.frame(height: 200)
			}
		}
		.padding(10)
	}
}

#Preview {
	CalendarView(selectedRow: 0)
}
