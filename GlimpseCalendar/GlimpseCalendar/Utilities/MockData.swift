//
//  MockData.swift
//  GlimpseCalendar
//
//  Created by Kody Buss on 3/4/24.
//

import SwiftUI

struct MockData {
	static let calendarRows: [Int: [CalendarItemView]] =
	[
		1:
		[
			CalendarItemView(day: 1),
			CalendarItemView(day: 2),
			CalendarItemView(day: 3),
			CalendarItemView(day: 4),
			CalendarItemView(day: 5),
			CalendarItemView(day: 6),
			CalendarItemView(day: 7)
		],
		2:
		[
			CalendarItemView(day: 8),
			CalendarItemView(day: 9),
			CalendarItemView(day: 10),
			CalendarItemView(day: 11),
			CalendarItemView(day: 12),
			CalendarItemView(day: 13),
			CalendarItemView(day: 14)
		],
		3:
		[
			CalendarItemView(day: 15),
			CalendarItemView(day: 16),
			CalendarItemView(day: 17),
			CalendarItemView(day: 18),
			CalendarItemView(day: 19),
			CalendarItemView(day: 20),
			CalendarItemView(day: 21)
		],
		4:
		[
			CalendarItemView(day: 22),
			CalendarItemView(day: 23),
			CalendarItemView(day: 24),
			CalendarItemView(day: 25),
			CalendarItemView(day: 26),
			CalendarItemView(day: 27),
			CalendarItemView(day: 28)
		],
		5:
		[
			CalendarItemView(day: 29),
			CalendarItemView(day: 30),
			CalendarItemView(day: 31)
		]
	]
}
