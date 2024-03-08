//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let day: Int
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		Rectangle()
			.overlay {
				Text("\(day)")
					.foregroundStyle(.gray)
			}
	}
	
	func setModifiers(selectedRow: Int, row: Int) -> some View {
		
		if(selectedRow == row){
			return self
				.frame(width: 250, height: 180, alignment: .center)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 5)
		}
		else {
			return self
				.frame(width: 45, height: 45)
				.clipShape(RoundedRectangle(cornerRadius: 5))
				.shadow(radius: 5)
		}
		
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(day: 1, events: ["Blah"])
				.setModifiers(selectedRow: 1, row: 0)
			
			CalendarItemView(day: 1, events: ["Blah"])
				.setModifiers(selectedRow: 1, row: 1)
		}
	}
}
