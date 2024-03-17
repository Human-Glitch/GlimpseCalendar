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
	
	var calendarRows : [Int: [CalendarItemView]]
	
    var body: some View {
		VStack(alignment: .center){
			Text("👁️‍🗨️ Glimpse")
				.font(.largeTitle)
				.fontWeight(.semibold)
				.frame(alignment: .top)
				.onTapGesture {
					selectedRow = 0
					selectedItem = nil
				}
			
			ForEach(calendarRows.sorted(by: { $0.0 < $1.0 }), id: \.0) { row, calendarRow in
				
					CalendarRowCarouselView(
						selectedItem: $selectedItem,
						selectedRow: $selectedRow,
						calendarItems: calendarRow,
						row: row,
						activeRow: selectedRow == row)
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
	CalendarView(calendarRows: MockData.calendarRows)
}
