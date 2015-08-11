//
//  Preferences.swift
//  Motivation
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class Preferences: NSObject {

	// MARK: - Properties

	static var birthdayDidChangeNotificationName = "Preferences.birthdayDidChangeNotificationName"

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

	private let defaults: ScreenSaverDefaults? = {
		let bundleIdentifier = NSBundle(forClass: Preferences.self).bundleIdentifier
		return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
	}()
}
