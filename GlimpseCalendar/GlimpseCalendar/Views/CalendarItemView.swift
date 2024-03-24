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
	var isSelected: Bool
	let day: String
	let index: Int
	
	var events: [String] = ["Blah", "Blah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		
		if(isHeader) {
			Text(day)
				.font(.footnote)
				.fontWeight(.semibold)
		}
		else if(isSelected){
			ZStack {
				Rectangle()
					.foregroundStyle(.quaternary)
					.background(.quaternary)
				
				VStack {
					HStack (spacing: 0){
						Text("\(index + 1)")
							.frame(width: 20, height: 20, alignment: .center)
							.font(.title3)
							.fontDesign(.monospaced)
							.fontWeight(.semibold)
							.background(.red.opacity(0.8))
							.foregroundStyle(.white)
							.padding([.leading, .top, .bottom])
						
						
						Text(day)
							.frame(width: 50, height: 20)
							.font(.title3)
							.fontDesign(.monospaced)
							.fontWeight(.semibold)
							.background(.white)
							.padding([.top, .bottom, .trailing])
						
						
						
						Spacer()
					}
					
					Spacer()
				}
				
			}
			
		}
		else {
			ZStack {
				Rectangle()
					.foregroundStyle(.quaternary)
					.background(.quaternary)
				
				VStack {
					Spacer()
					
					HStack (alignment: .center) {
						Spacer()
						
						Text("\(index + 1)")
							.frame(width: 20, height: 20, alignment: .center)
							.font(.title3)
							.fontDesign(.monospaced)
							.fontWeight(.semibold)
							.padding()
							.background(.red.opacity(0.8))
							.clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
							.foregroundStyle(.white)
							
						
						Spacer()
					}
					
					Spacer()
				}
				
			}
		}
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(isHeader: true, isSelected: false,  day: "MON", index: 0)
			
			Spacer()
			
			CalendarItemView(isHeader: false, isSelected: true, day: "MON", index: 1)
			
			Spacer()
			
			CalendarItemView(isHeader: false, isSelected: false, day: "MON", index: 1)
		}
	}
}
