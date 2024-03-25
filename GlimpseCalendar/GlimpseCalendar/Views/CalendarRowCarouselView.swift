//
//  CalendarRowCarouselView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/11/24.
//

import SwiftUI

struct CalendarRowCarouselView: View {
	@Binding var selectedItem: CalendarItemView?
	@Binding var selectedRow: Int
	@State private var currentIndex: Int = 0
	@GestureState private var dragOffset: CGFloat = 0
	
	let calendarItems: [CalendarItemView]
	let row: Int
	var activeRow: Bool
	
	var body: some View {
		
		if(row != 0 && activeRow) {
			VStack {
				ZStack {
					ForEach(calendarItems) { calendarItem in
						calendarItem
							.modifier(CustomCalendarRowStyle(row: row, activeRow: activeRow, calendarItem: calendarItem))
							.opacity(calendarItem.index == currentIndex ? 1.0 : 0.8)
							.scaleEffect(calendarItem.index == currentIndex ? 1.2 : 0.5)
							.offset(x: CGFloat(calendarItem.index - currentIndex) * 220 + dragOffset, y: 0)
							.onTapGesture {
								withAnimation(.interactiveSpring(duration: 0.4))  {
									currentIndex = calendarItem.index
									selectedItem = calendarItem
									selectedRow = row
								}
							}
					}
				}
				.gesture(DragGesture()
					.onEnded({ value in
						let threshold: CGFloat = 50
						if value.translation.width > threshold {
							withAnimation(.interactiveSpring(duration: 0.5))  {
								currentIndex = max(0, currentIndex - 1)
								
								selectedItem = calendarItems[currentIndex]
								selectedRow = row
							}
						} else if value.translation.width < -threshold {
							withAnimation(.interactiveSpring(duration: 0.5)) {
								currentIndex = min(calendarItems.count - 1, currentIndex + 1)
								
								selectedItem = calendarItems[currentIndex]
								selectedRow = row
							}
						}
					}))
			}
		} else {
			HStack(alignment: .center) {
				let calendarItems = calendarItems
				
				ForEach(calendarItems) { calendarItem in
					calendarItem
						.modifier(CustomCalendarRowStyle(row: row, activeRow: activeRow, calendarItem: calendarItem)) // Apply the drag offset to position
						.onTapGesture {
							withAnimation(.interactiveSpring(duration: 0.4))  {
								currentIndex = calendarItem.index
								selectedItem = calendarItem
								selectedRow = row
							}
						}
					
					
				}
			}
			.padding(5)
		}
	}
}

struct CustomCalendarRowStyle: ViewModifier {
	var row: Int
	var activeRow: Bool
	var calendarItem: CalendarItemView
	
	func body(content: Content) -> some View {
		if(row == 0) {
			content
				.frame(width: 35, height: 35)
				.padding(5)
		}
		else {
			if(activeRow) {
				content
					.frame(width: 250, height: 180, alignment: .center)
					.clipShape(RoundedRectangle(cornerRadius: 20))
					.shadow(radius: 5, y: 10)
					.padding(10)
			}
			else {
				ZStack {
					content
						.frame(width: 20, height: 20)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						.shadow(radius: 5, y: 10)
						.padding(5)
						.foregroundStyle(.quaternary)
						.background(.quaternary)
					
					VStack {
						HStack (alignment: .center) {
							Text("\(calendarItem.index + 1)")
								.frame(width: 20, height: 20, alignment: .center)
								.font(.title3)
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
}

#Preview {
	VStack{
		CalendarRowCarouselView(
			selectedItem: .constant(nil),
			selectedRow: .constant(0),
			calendarItems: MockData.calendarRows[0]!,
			row: 0,
			activeRow: false)
		
		CalendarRowCarouselView(
			selectedItem: .constant(nil),
			selectedRow: .constant(0),
			calendarItems: MockData.calendarRows[1]!,
			row: 1,
			activeRow: false)
		
		CalendarRowCarouselView(
			selectedItem: .constant(nil),
			selectedRow: .constant(2),
			calendarItems: MockData.calendarRows[2]!,
			row: 2,
			activeRow: true)
	}
}
