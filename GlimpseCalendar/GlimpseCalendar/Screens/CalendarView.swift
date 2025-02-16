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
	@State var selectedItemID: Int? = nil  
	@State var selectedIndex: Int = 0
	@State var selectedMonth: Date = Date()
	@State private var synced = false
	
	private var today = Date()
	private var calendarYear = CalendarFactory.getCalendarYear(for: Date())
	
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
					selectedItemID = nil
				}
				.padding(.bottom, 0)
			
			HStack(alignment: .bottom) {
				Text(CalendarFactory.getMonthAndYear(for: selectedMonth))
					.font(.title)
					.fontDesign(.monospaced)
					.fontWeight(.heavy)
					.minimumScaleFactor(0.2)
					.scaledToFit()
				
				Spacer()
				
				Button {
					selectedMonth = today
					clearState()
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
					clearState()
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
					clearState()
				} label: {
					Image(systemName: "chevron.down")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
						.padding(5)
				}
			}
			
			HStack(alignment: .center, spacing: 5){
				ForEach(CalendarFactory.daysOfWeek, id: \.self) { day in
					Text(day)
						.frame(width: 50, height: 35, alignment: .center)
						.font(.title3)
						.fontWeight(.semibold)
				}
			}
			.frame(width: 400, height: 50)
			
			let calendarViews = buildCalendarByMonth(calendarYear: calendarYear, selectedMonth: selectedMonth)
			
			LazyVStack {
				ForEach(calendarViews.indices, id: \.self) { index in
					calendarViews[index]
						.padding(5)
						.transition(.asymmetric(insertion: .scale, removal: .opacity))
				}
			}
			.animation(.bouncy, value: selectedRow)
			
			Spacer()
		}
		.onChange(of: eventKitManager.ekEvents) { oldEvents, newEvents in
			if !self.synced {
				self.syncCalendarWithEventKit()
				self.synced = true
			}
		}
		.padding([.horizontal, .top], 10)
	}
	
	private func clearState() {
		selectedRow = -1
		selectedItemID = nil
		selectedIndex = 0
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
	
	func buildCalendarByMonth(calendarYear: CalendarYear, selectedMonth: Date) -> [AnyView] {
		let calendar = Calendar.current
		let month = calendar.component(.month, from: selectedMonth)
		
		var views: [AnyView] = []
		for calendarWeek in calendarYear.calendarMonths[month - 1].calendarWeeks {
			
			if calendarWeek.weekNumber == selectedRow {
				let view = AnyView(
					ActiveCalendarRowCarouselView(
						selectedItemID: $selectedItemID,
						selectedRow: $selectedRow,
						selectedIndex: $selectedIndex,
						calendarDays: calendarWeek.calendarDays,
						row: calendarWeek.weekNumber)
				)
				views.append(view)
			} else {
				let view = AnyView(
					InactiveCalendarRowCarouselView(
						selectedRow: $selectedRow,
						selectedIndex: $selectedIndex,
						calendarDays: .constant(calendarWeek.calendarDays),
						row: calendarWeek.weekNumber)
				)
				views.append(view)
			}
		}
		
		return views
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
