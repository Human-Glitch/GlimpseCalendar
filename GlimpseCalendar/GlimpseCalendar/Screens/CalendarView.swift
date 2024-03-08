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
			
			HStack(alignment: .center, spacing: 13){
				Text("SUN")
				Text("MON")
				Text("TUE")
				Text("WED")
				Text("THU")
				Text("FRI")
				Text("SAT")
				Text("SUN")
			}
			
			ForEach(MockData.calendarRows.sorted(by: { $0.0 < $1.0 }), id: \.0) { calendarRow in
				CalendarRowView(
					selectedItem: $selectedItem,
					selectedItemId: $selectedItemId,
					selectedRow: $selectedRow,
					calendarItems: MockData.calendarRows,
					row: calendarRow.key)
			}.padding([.horizontal])
			
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

#Preview {
	CalendarView(selectedRow: 0)
}
