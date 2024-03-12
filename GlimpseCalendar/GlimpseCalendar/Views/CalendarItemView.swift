//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let isHeader: Bool
	let day: String
	let index: Int
	
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		
		if(isHeader) {
			Text(day)
				.font(.footnote)
				.fontWeight(.semibold)
		}
		else {
			Rectangle()
		}
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(isHeader: true, day: "MON", index: 0)
			
			Spacer()
			
			CalendarItemView(isHeader: false, day: "MON", index: 1)
		}
	}
}
