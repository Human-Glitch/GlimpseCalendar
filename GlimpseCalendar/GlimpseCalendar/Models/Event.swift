//
//  Event.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 4/29/24.
//

import Foundation
import SwiftData

@Model
class Event: Hashable {
	init(name: String,
		startTime: Date,
		endTime: Date,
		location: String) {
		self.name = name
		self.startTime = startTime
		self.endTime = endTime
		self.location = location
	}
	
	var name: String
	var startTime: Date
	var endTime: Date
	var location: String
}
