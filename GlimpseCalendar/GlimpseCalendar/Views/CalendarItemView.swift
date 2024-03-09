//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let date: String
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		VStack {
			Rectangle()
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 5)
		}
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(date: "MON")
		}
	}
}
