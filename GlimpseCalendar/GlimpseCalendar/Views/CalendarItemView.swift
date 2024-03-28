//
//  CalendarItemView.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct CalendarItemView: View, Hashable, Identifiable {
	let id = UUID()
	let day: String
	let index: Int
	
	var events: [String] = ["Blah", "BlahBlahBlahBlahBlahBlahBlahBlahBlahBlahBlahBlahBlah", "Blah", "Blah", "Blah"]
	
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.quaternary)
				.background(.clear)
			
			VStack{
				Spacer(minLength: 30)
				List(events, id: \.self) { event in
					VStack{
						HStack{
							VStack{
								Text("10 am")
								Text("11 am")
							}
							.padding(5)
							.foregroundColor(.white)
							.background(.gray)
							.cornerRadius(10)
							
							VStack{
								HStack{
									Label(event, systemImage: "calendar")
										.lineLimit(1)
										.padding(.trailing)
										.scaledToFit()
										.minimumScaleFactor(0.8)
									
									Spacer()
								}
								
								HStack{
									Label("Home", systemImage: "mappin.and.ellipse")
										.bold()
									
									Spacer()
								}
							}
						}
						.font(.footnote)
					}
				}
				.listStyle(.plain)
				.font(.footnote)
				.fontWeight(.semibold)
			}
			
			VStack{
				HStack (spacing: 0){
					Text(day)
						.frame(width: 50, height: 20)
						.font(.title3)
						.fontDesign(.monospaced)
						.fontWeight(.bold)
						.background(.white)
						.cornerRadius(5)
						.padding(.leading, 15)
					
					Text("\(index + 1)")
						.frame(width: 25, height: 25, alignment: .center)
						.font(.title3)
						.fontDesign(.monospaced)
						.fontWeight(.bold)
						.background(.red.opacity(0.8))
						.cornerRadius(10)
						.foregroundStyle(.white)
						.padding(.leading, 10)
					
					Spacer()
				}
				.frame(height: 30)
				
				Spacer()
			}
			
		}
		
	}
}

#Preview {
	Group {
		VStack {
			CalendarItemView(day: "MON", index: 0)
		}
	}
}
