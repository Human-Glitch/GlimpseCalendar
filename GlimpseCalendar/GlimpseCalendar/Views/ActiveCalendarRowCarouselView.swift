//
//  CalendarRowCarouselView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/11/24.
//

import SwiftUI

struct ActiveCalendarRowCarouselView: View, Identifiable {
	let id = UUID()
	@Binding var selectedItem: CalendarItemView?
	@Binding var selectedRow: Int
	@Binding var selectedIndex: Int
	@GestureState private var dragOffset: CGFloat = 0
	
	let calendarDays: [CalendarDay]
	let row: Int
	
	var body: some View {
		
		let calendarItems: [CalendarItemView] = buildCalendarItems(calendarDays: calendarDays)
		
		VStack {
			ZStack {
				ForEach(calendarItems) { calendarItem in
					
					if(calendarItem.weekDay != "Blank") {
						
						calendarItem
							.modifier(CustomCalendarRowStyle(calendarItem: calendarItem))
							.opacity(calendarItem.index == selectedIndex ? 1.0 : 0.8)
							.scaleEffect(calendarItem.index == selectedIndex ? 1.2 : 0.5)
							.offset(x: CGFloat(calendarItem.index - selectedIndex) * 220 + dragOffset, y: 0)
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.2)) {
									selectedIndex = calendarItem.index
									selectedItem = calendarItem
									selectedRow = row
								}
							}
							.gesture(
								DragGesture()
									.onEnded { value in
										let threshold: CGFloat = 50
										withAnimation(.easeInOut(duration: 0.2)) {
											if value.translation.width > threshold {
												selectedIndex = max(0, selectedIndex - 1)
											} else if value.translation.width < -threshold {
												selectedIndex = min(calendarDays.count - 1, selectedIndex + 1)
											}
											selectedItem = calendarItems[selectedIndex]
											selectedRow = row
										}
									}
							)
					}
				}
			}
		}
	}
	
	func buildCalendarItems(calendarDays: [CalendarDay]) -> [CalendarItemView] {
		var calendarItems: [CalendarItemView] = []
		for calendarDay in calendarDays {
			let index = calendarDays.firstIndex(of: calendarDay)!
			
			let calendarItem = CalendarItemView(weekDay: calendarDay.weekDay, date: calendarDay.date, index: index)
												
			calendarItems.append(calendarItem)
		}
		
		return calendarItems
	}
}

struct CustomCalendarRowStyle: ViewModifier {
	var calendarItem: CalendarItemView
	
	func body(content: Content) -> some View {
		content
			.frame(width: 250, height: 245, alignment: .center)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.shadow(radius: 10, y: 5)
			.padding(20)
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
