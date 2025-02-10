//
//  CalendarRowCarouselView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/11/24.
//

import SwiftUI

struct InactiveCalendarRowCarouselView: View {
	@Binding var selectedRow: Int
	@Binding var selectedIndex: Int
	@Binding var  calendarDays: [CalendarDay]
	let row: Int
	
	var body: some View {
		
		HStack(alignment: .center) {
			ForEach($calendarDays, id: \.self) { calendarDay in
				
				if(calendarDay.weekDay.wrappedValue == "Blank") {
					Rectangle()
						.frame(width: 20, height: 20)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.padding(13)
						.foregroundStyle(.clear)
						.background(.clear)
					
				} else {
					Rectangle()
						.modifier(InactiveCustomCalendarRowStyle(calendarDay: calendarDay.wrappedValue))
						.onTapGesture {
							selectedIndex = calendarDay.index.wrappedValue
							selectedRow = row
						}
				}
			}
			
			Spacer()
		}
		.frame(width: 375)
	}
}

func getDayNumber(date: Date) -> String {
	let formatter = DateFormatter()
	formatter.dateFormat = "d"

	return formatter.string(from: date)
}

struct InactiveCustomCalendarRowStyle: ViewModifier {
	var calendarDay: CalendarDay
	
	func body(content: Content) -> some View {
		ZStack {
			content
				.frame(width: 20, height: 20)
				.clipShape(RoundedRectangle(cornerRadius: 10))
				.padding(13)
				.foregroundStyle(.clear)
			
			VStack {
				HStack (alignment: .center) {
					Text(getDayNumber(date: calendarDay.date))
						.frame(width: 20, height: 20, alignment: .center)
						.font(.title3)
						.minimumScaleFactor(0.5)
						.scaledToFit()
						.fontWeight(.semibold)
						.padding(13)
						.background(.red.opacity(0.8))
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.foregroundStyle(.white)
				}
			}
		}
	}
}

//#Preview {
//	VStack{
//		CalendarRowCarouselView(
//			selectedItem: .constant(nil),
//			selectedRow: .constant(0), selectedIndex: .constant(0),
//			calendarItems: MockData.calendarRows[0].calendarItemViews,
//			row: 1,
//			activeRow: false)
//		
//		CalendarRowCarouselView(
//			selectedItem: .constant(nil),
//			selectedRow: .constant(2), 
//			selectedIndex: .constant(0),
//			calendarItems: MockData.calendarRows[1].calendarItemViews,
//			row: 2,
//			activeRow: true)
//	}
//}
