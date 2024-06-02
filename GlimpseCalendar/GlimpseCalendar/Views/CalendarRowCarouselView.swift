//
//  CalendarRowCarouselView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/11/24.
//

import SwiftUI

struct CalendarRowCarouselView: View, Identifiable {
	let id = UUID()
	@Binding var selectedItem: CalendarItemView?
	@Binding var selectedRow: Int
	@Binding var selectedIndex: Int
	@GestureState private var dragOffset: CGFloat = 0
	
	let calendarDays: [CalendarDay]
	let row: Int
	var activeRow: Bool
	
	var body: some View {
		
		let calendarItems: [CalendarItemView] = buildCalendarItems(calendarDays: calendarDays)
		
		if(row > -1 && activeRow) {
			VStack {
				ZStack {
					ForEach(calendarItems) { calendarItem in
						
						if(calendarItem.weekDay != "Blank") {
							
							calendarItem
								.modifier(CustomCalendarRowStyle(row: row, activeRow: activeRow, calendarItem: calendarItem))
								.opacity(calendarItem.index == selectedIndex ? 1.0 : 0.8)
								.scaleEffect(calendarItem.index == selectedIndex ? 1.2 : 0.5)
								.offset(x: CGFloat(calendarItem.index - selectedIndex) * 220 + dragOffset, y: 0)
								.onTapGesture {
									//withAnimation(.interactiveSpring(duration: 0.4)) {
										selectedIndex = calendarItem.index
										selectedItem = calendarItem
										selectedRow = row
									//}
								}
						}
					}
				}
				.gesture(DragGesture()
					.onEnded({ value in
						let threshold: CGFloat = 50
						if value.translation.width > threshold {
							//withAnimation(.interactiveSpring(duration: 0.4))  {
								selectedIndex = max(0, selectedIndex - 1)
								
								selectedItem = calendarItems[selectedIndex]
								selectedRow = row
							//}
						} else if value.translation.width < -threshold {
							//withAnimation(.interactiveSpring(duration: 0.4)) {
								selectedIndex = min(calendarDays.count - 1, selectedIndex + 1)
								
								selectedItem = calendarItems[selectedIndex]
								selectedRow = row
							//}
						}
					}))
			}
		} else {
			HStack(alignment: .center) {
				ForEach(calendarItems) { calendarItem in
					
					if(calendarItem.weekDay == "Blank") {
						Rectangle()
							.frame(width: 20, height: 20)
							.clipShape(RoundedRectangle(cornerRadius: 10))
							.padding(13)
							.foregroundStyle(.clear)
							.background(.clear)
						
					} else {
						calendarItem
							.modifier(CustomCalendarRowStyle(row: row, activeRow: activeRow, calendarItem: calendarItem)) // Apply the drag offset to position
							.onTapGesture {
								//withAnimation(.interactiveSpring(duration: 0.4))  {
									selectedIndex = calendarItem.index
									selectedItem = calendarItems[selectedIndex]
									selectedRow = row
								//}
							}
					}
				}
				
				Spacer()
			}
			.frame(width: 375)
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
	var row: Int
	var activeRow: Bool
	var calendarItem: CalendarItemView
	
	func body(content: Content) -> some View {
		
		if(activeRow) {
			content
				.frame(width: 250, height: 245, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 10, y: 5)
				.padding(20)
		}
		else {
			ZStack {
				content
					.frame(width: 20, height: 20)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.padding(13)
					.foregroundStyle(.clear)
				
				VStack {
					HStack (alignment: .center) {
						Text("\(calendarItem.dayNumber)")
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
