//
//  ContentView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/2/24.
//

import SwiftUI
import EventKit
import SwiftData

struct CalendarView: View {
	@Environment(\.modelContext) var modelContext
	
	@Query(sort: \Event.startTime)
	private var existingEvents: [Event]
	
	@ObservedObject var eventKitManager = EventKitManager()
	
	@State var selectedRow = -1
	@State var selectedItem: CalendarItemView?
	@State var selectedIndex: Int = 0
	@State var selectedMonth: Date = Date()
	@State private var synced = false
	
	private var today = Date()
	private var calendarYear = MockData.getCalendarYear(for: Date())
	
	init() {
		eventKitManager.requestAccess(forYear: calendarYear.year)
	}
	
	var body: some View {
		VStack(alignment: .center, spacing: 5){
			
			Text("👁️‍🗨️ Glimpse")
				.font(.system(size: 36, weight: .semibold, design: .monospaced))
				.frame(alignment: .top)
				.onTapGesture {
					selectedRow = -1
					selectedItem = nil
				}
				.padding(.bottom, 0)
			
			HStack(alignment: .bottom) {
				Text(MockData.getMonthAndYear(for: selectedMonth))
					.font(.title)
					.fontDesign(.monospaced)
					.fontWeight(.heavy)
					.minimumScaleFactor(0.2)
					.scaledToFit()
				
				Spacer()
				
				Button {
					selectedMonth = today
					
					selectedRow = -1
					selectedItem = nil
					selectedIndex = 0
					
				} label: {
					Image(systemName: "clock.circle.fill")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
						.padding(5)
				}
				
				Button {
					let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth)!
					
					selectedMonth = previousMonth
					
					selectedRow = -1
					selectedItem = nil
					selectedIndex = 0
				} label: {
					Image(systemName: "chevron.up")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
						.padding(5)
				}
				
				Button {
					let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth)!
					
					selectedMonth = nextMonth
					
					selectedRow = -1
					selectedItem = nil
					selectedIndex = 0
					
				} label: {
					Image(systemName: "chevron.down")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
						.padding(5)
				}
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
			
			let calendarWeeks = buildCalendarByMonth(calendarYear: calendarYear, selectedMonth: selectedMonth)
			
			ForEach(calendarWeeks) { calendarWeek in
				calendarWeek
					.padding(5)
			}
			
			Spacer()
		}
		.onAppear {
			if(synced) { return }
			syncCalendarWithEventKit()
			synced = true
		}
		.padding([.horizontal, .top], 10)
	}
	
	func syncCalendarWithEventKit() {
		let events = eventKitManager.ekEvents.map { self.convertToEvent(ekEvent: $0) }
		
		for event in events {
			if !self.existingEvents.contains(where: {
				$0.name == event.name &&
				$0.startTime == event.startTime &&
				$0.endTime == event.endTime }) {
				self.modelContext.insert(event)
			}
		}
		
		do {
			try self.modelContext.save()
		} catch {
			print("Sync failed to save.")
		}
	}
	
	func buildCalendarByMonth(calendarYear: CalendarYear, selectedMonth: Date) -> [CalendarRowCarouselView] {
		let calendar = Calendar.current
		let month = calendar.component(.month, from: selectedMonth)
		
		var calendarWeeks: [CalendarRowCarouselView] = []
		for calendarWeek in calendarYear.calendarMonths[month - 1].calendarWeeks {
			
			calendarWeeks.append(CalendarRowCarouselView(
				selectedItem: $selectedItem,
				selectedRow: $selectedRow,
				selectedIndex: $selectedIndex,
				calendarDays: calendarWeek.calendarDays,
				row: calendarWeek.weekNumber,
				activeRow: selectedRow == calendarWeek.weekNumber))
		}
		
		return calendarWeeks
	}
	
	func convertToEvent(ekEvent: EKEvent) -> Event {
		let event = Event(
			name: ekEvent.title,
			startTime: ekEvent.startDate,
			endTime: ekEvent.endDate,
			location: ekEvent.location ?? "")

		return event
	}
}

#Preview {
	CalendarView()
}
