//
//  TypeExtensions.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 4/29/24.
//

import Foundation

extension Date {
	func formattedTime(format: String = "h:mm a") -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
}
