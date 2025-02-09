//
//  TypeExtensions.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 4/29/24.
//

import Foundation

extension Date {
	// New cached formatters
	private static var formatters = [String: DateFormatter]()

	private static func formatter(for format: String) -> DateFormatter {
		if let formatter = formatters[format] {
			return formatter
		}
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatters[format] = formatter
		return formatter
	}

	func formattedTime(format: String = "h:mm a") -> String {
		let formatter = Date.formatter(for: format)
		return formatter.string(from: self)
	}
}
