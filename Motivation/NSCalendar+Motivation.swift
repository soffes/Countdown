//
//  NSCalendar+Motivation.swift
//  Motivation
//
//  Created by Sam Soffes on 8/14/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import Foundation

extension NSCalendar {
	func daysInYear(date: NSDate = NSDate()) -> Int? {
		let year = components([NSCalendarUnit.Year], fromDate: date).year
		return daysInYear(year)
	}

	func daysInYear(year: Int) -> Int? {
		guard let begin = lastDayOfYear(year - 1), end = lastDayOfYear(year) else { return nil }
		return components([NSCalendarUnit.Day], fromDate: begin, toDate: end, options: []).day
	}

	func lastDayOfYear(year: Int) -> NSDate? {
		let components = NSDateComponents()
		components.year = year
		guard let years = dateFromComponents(components) else { return nil }

		components.month = rangeOfUnit(NSCalendarUnit.Month, inUnit: NSCalendarUnit.Year, forDate: years).length
		guard let months = dateFromComponents(components) else { return nil }

		components.day = rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: months).length

		return dateFromComponents(components)
	}
}
