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
	private var calendarYear = MockData.getCalendarYear(for: Date())
	
	var body: some View {
			VStack(alignment: .center, spacing: 5){
				Text("👁️‍🗨️ Glimpse")
					.font(.system(size: 38, weight: .semibold, design: .monospaced))
					.frame(alignment: .top)
					.onTapGesture {
						selectedRow = -1
						selectedItem = nil
					}
					.padding(.bottom, 30)
				
				HStack(alignment: .bottom) {
					Text("January 2024")
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
				
				let calendarWeeks = buildCalendarByMonth(calendarYear: calendarYear)
				ForEach(calendarWeeks) { calendarWeek in
					calendarWeek
				}
				
				Spacer()
			}
			.padding(10)
	}
	
	func buildCalendarByMonth(calendarYear: CalendarYear) -> [CalendarRowCarouselView] {
		
		var calendarWeeks: [CalendarRowCarouselView] = []
		for calendarWeek in calendarYear.calendarMonths[0].calendarWeeks {
			var calendarItems: [CalendarItemView] = []
			for calendarDay in calendarWeek.calendarDays {
				let index = calendarWeek.calendarDays.firstIndex(of: calendarDay)!
				let calendarItem = CalendarItemView(weekDay: calendarDay.weekDay, date: calendarDay.date, index: index)
				calendarItems.append(calendarItem)
			}
			
			calendarWeeks.append(CalendarRowCarouselView(
				selectedItem: $selectedItem,
				selectedRow: $selectedRow,
				selectedIndex: $selectedIndex,
				calendarItems: calendarItems,
				row: calendarWeek.weekNumber,
				activeRow: selectedRow == calendarWeek.weekNumber))
		}
		
		return calendarWeeks
	}
}

#Preview {
	CalendarView()
}
