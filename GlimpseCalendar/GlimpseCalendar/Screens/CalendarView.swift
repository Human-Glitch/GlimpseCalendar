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
    
    // State to trigger calendar refresh
    @State private var calendarRefreshToggle: Bool = false
    @State private var forceRefresh: UUID = UUID()
	
	// Use EnvironmentObject for EventKitManager
	@EnvironmentObject var eventKitManager: EventKitManager
	
	// Accept the view model via dependency injection
	@ObservedObject private var viewModel: CalendarViewModel
	
	// Initialize with injected viewModel
	init(viewModel: CalendarViewModel) {
		self.viewModel = viewModel
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
							.id("\(index)-\(calendarRefreshToggle)-\(forceRefresh)") // More aggressive ID forcing refresh
					}
				}
				.animation(.bouncy, value: viewModel.selectedRow)
				
				Spacer()
			}
			.navigationDestination(isPresented: $viewModel.showSettings) {
				SettingsView()
					.environmentObject(eventKitManager)
			}
			.onAppear {
				viewModel.requestCalendarAccess()
			}
			.onChange(of: eventKitManager.ekEvents) { oldEvents, newEvents in
				if !viewModel.synced {
					viewModel.syncCalendarWithEventKit(existingEvents: existingEvents)
				}
			}
            // More specific handling of event changes
            .onReceive(viewModel.dataService.eventChangedPublisher) { changeType in
                // Different handling based on change type
                switch changeType {
                case .added, .deleted:
                    // Completely regenerate views for adds/deletes
                    forceRefresh = UUID() // Force a complete refresh
                    
                    // Add a slight delay to ensure SwiftData has updated
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        calendarRefreshToggle.toggle()
                    }
                    
                case .updated, .synced:
                    // For updates, a simple toggle is sufficient
                    calendarRefreshToggle.toggle()
                }
            }
			.padding([.horizontal, .top], 10)
		}
        .id(forceRefresh) // Force the entire view to rebuild when needed
	}
}

#Preview {
	let container = try! ModelContainer(for: Event.self)
	let context = ModelContext(container)
	let dataService = DataService(modelContext: context)
	
	let previewView = CalendarView(viewModel: CalendarViewModel(
		eventKitManager: EventKitManager(),
		dataService: dataService
	))
	.environmentObject(EventKitManager())
	.modelContainer(container)
	
	return previewView
}
