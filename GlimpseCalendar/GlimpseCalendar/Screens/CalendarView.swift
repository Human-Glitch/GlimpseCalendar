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
	
	// Use EnvironmentObject for EventKitManager
	@EnvironmentObject var eventKitManager: EventKitManager
	
	// Use the CalendarViewModel - change to a StateObject
	@StateObject private var viewModel: CalendarViewModel
	
	// Initialize with dependencies
	init() {
		// We'll initialize the view model properly, can't modify self in onAppear
		let eventKitManager = EventKitManager()
		
		// Create a temporary ModelContext for initialization
		let container = try! ModelContainer(for: Event.self)
		let context = ModelContext(container)
		
		_viewModel = StateObject(wrappedValue: CalendarViewModel(
			eventKitManager: eventKitManager, 
			modelContext: context
		))
	}
	
	private var today = Date()
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 5){
				
				HStack {
					Spacer()
					
					Text("👁️‍🗨️ Glimpse")
						.font(.system(size: 36, weight: .semibold, design: .monospaced))
						.frame(alignment: .top)
						.onTapGesture {
							viewModel.clearState()
						}
					
					Spacer()
					
					Button {
						viewModel.showSettings = true
					} label: {
						Image(systemName: "gear")
							.resizable()
							.scaledToFit()
							.frame(width: 24, height: 24)
					}
				}
				.padding(.bottom, 0)
				
				HStack(alignment: .bottom) {
					Text(CalendarFactory.getMonthAndYear(for: viewModel.selectedMonth))
						.font(.title)
						.fontDesign(.monospaced)
						.fontWeight(.heavy)
						.minimumScaleFactor(0.2)
						.scaledToFit()
					
					Spacer()
					
					Button {
						viewModel.goToToday()
					} label: {
						Image(systemName: "clock.circle.fill")
							.resizable()
							.scaledToFit()
							.frame(width: 30, height: 30)
							.padding(5)
					}
					
					Button {
						viewModel.goToPreviousMonth()
					} label: {
						Image(systemName: "chevron.up")
							.resizable()
							.scaledToFit()
							.frame(width: 30, height: 30)
							.padding(5)
					}
					
					Button {
						viewModel.goToNextMonth()
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
				
				let calendarViews = viewModel.buildCalendarByMonth(existingEvents: existingEvents)
				
				LazyVStack {
					ForEach(calendarViews.indices, id: \.self) { index in
						calendarViews[index]
							.padding(5)
							.transition(.asymmetric(insertion: .scale, removal: .opacity))
					}
				}
				.animation(.bouncy, value: viewModel.selectedRow)
				
				Spacer()
			}
			.navigationDestination(isPresented: $viewModel.showSettings) {
				SettingsView()
			}
			.onAppear {
				// We can't reassign the StateObject in onAppear, instead update its properties
				viewModel.requestCalendarAccess()
			}
			.onChange(of: eventKitManager.ekEvents) { oldEvents, newEvents in
				if !viewModel.synced {
					viewModel.syncCalendarWithEventKit(existingEvents: existingEvents)
				}
			}
			.padding([.horizontal, .top], 10)
		}
	}
}

#Preview {
	CalendarView()
		.environmentObject(EventKitManager())
}
