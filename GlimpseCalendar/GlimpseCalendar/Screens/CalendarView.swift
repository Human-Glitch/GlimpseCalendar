//
//  ContentView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI

struct CalendarView: View {
	@State var selectedRow = -1
	@State var selectedItem: CalendarItemView?
	@State var selectedIndex: Int = 0
	
	var calendarRows : [Int: [CalendarItemView]]
	
    var body: some View {
		VStack(alignment: .center, spacing: 5){
			Text("👁️‍🗨️ Glimpse")
				.font(.system(size: 38, weight: .semibold, design: .monospaced))
				.frame(alignment: .top)
				.onTapGesture {
					selectedRow = -1
					selectedItem = nil
				}
				.padding(.bottom, 50)
			
			HStack(alignment: .bottom) {
				Text("March 2024")
					.font(.largeTitle)
					.fontDesign(.monospaced)
					.fontWeight(.heavy)
				
				Spacer()
			}
			
			HStack(alignment: .center, spacing: 5){
				ForEach(MockData.daysOfWeek, id: \.self) { day in
					Text(day)
						.frame(width: 50, height: 35, alignment: .center)
						.font(.title3)
						.fontWeight(.semibold)
				}
			}
			.frame(width: 400, height: 50)
			
			ForEach(calendarRows.sorted(by: { $0.0 < $1.0 }), id: \.0) { row, calendarRow in
				
					CalendarRowCarouselView(
						selectedItem: $selectedItem,
						selectedRow: $selectedRow,
						selectedIndex: $selectedIndex,
						calendarItems: calendarRow,
						row: row,
						activeRow: selectedRow == row)
			}
			
			Spacer()
		}
		.padding(10)
	}
}

#Preview {
	CalendarView(calendarRows: MockData.calendarRows)
}
