//
//  Preferences.swift
//  Countdown
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class Preferences: NSObject {

	// MARK: - Properties

	static let dateDidChangeNotificationName = "Preferences.dateDidChangeNotification"
	private static let dateKey = "Date2"

	var date: NSDate? {
		get {
			let timestamp = defaults?.objectForKey(self.dynamicType.dateKey) as? NSTimeInterval
			return timestamp.map { NSDate(timeIntervalSince1970: $0) }
		}

		set {
			if let date = newValue {
				defaults?.setObject(date.timeIntervalSince1970, forKey: self.dynamicType.dateKey)
			} else {
				defaults?.removeObjectForKey(self.dynamicType.dateKey)
			}
			defaults?.synchronize()

			NSNotificationCenter.defaultCenter().postNotificationName(self.dynamicType.dateDidChangeNotificationName, object: newValue)
		}
	}

	private let defaults: ScreenSaverDefaults? = {
		let bundleIdentifier = NSBundle(forClass: Preferences.self).bundleIdentifier
		return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
	}()
}
