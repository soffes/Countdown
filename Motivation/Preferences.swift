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
		}
	}

	private let defaults: ScreenSaverDefaults? = {
		if let bundleIdentifier = NSBundle(forClass: Preferences.self).bundleIdentifier {
			return ScreenSaverDefaults.defaultsForModuleWithName(bundleIdentifier) as? ScreenSaverDefaults
		}
		return nil
	}()
}
