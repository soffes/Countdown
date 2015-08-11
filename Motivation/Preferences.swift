//
//  Preferences.swift
//  Motivation
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

enum MotivationLevel: UInt {
	case Light, Moderate, Terrifying

	var decimalPlaces: UInt {
		switch self {
		case Light: return 7
		case Moderate: return 8
		case Terrifying: return 9
		}
	}
}

class Preferences: NSObject {

	// MARK: - Properties

	static var birthdayDidChangeNotificationName = "Preferences.birthdayDidChangeNotification"
	static var motivationLevelDidChangeNotificationName = "Preferences.motivationLevelDidChangeNotification"

	var birthday: NSDate? {
		get {
			let timestamp = defaults?.objectForKey("Birthday") as? NSTimeInterval
			return timestamp.map { NSDate(timeIntervalSince1970: $0) }
		}

		set {
			if let date = newValue {
				defaults?.setObject(date.timeIntervalSince1970, forKey: "Birthday")
			} else {
				defaults?.removeObjectForKey("Birthday")
			}
			defaults?.synchronize()

			NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.birthdayDidChangeNotificationName, object: newValue)
		}
	}

	var motivationLevel: MotivationLevel {
		get {
			let uint = defaults?.objectForKey("MotivationLevel") as? UInt
			return uint.flatMap { MotivationLevel(rawValue: $0) } ?? .Terrifying
		}

		set {
			defaults?.setObject(newValue.rawValue, forKey: "MotivationLevel")
			defaults?.synchronize()

			NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.motivationLevelDidChangeNotificationName, object: newValue.rawValue)
		}
	}

	private let defaults: ScreenSaverDefaults? = {
		let bundleIdentifier = NSBundle(forClass: Preferences.self).bundleIdentifier
		return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
	}()
}
