//
//  AgeView.swift
//  Motivation
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class AgeView: ScreenSaverView {

	// MARK: - Properties

	private let textLabel: NSTextField = {
		let label = NSTextField()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.editable = false
		label.drawsBackground = false
		label.bordered = false
		label.bezeled = false
		label.selectable = false
		label.textColor = .whiteColor()
		return label
	}()

	private lazy var configurationWindowController: NSWindowController = {
		return ConfigurationWindowController()
	}()

	private var motivationLevel: MotivationLevel

	private var birthday: NSDate? {
		didSet {
			updateFont()
		}
	}


	// MARK: - Initializers

	convenience init() {
		self.init(frame: CGRectZero, isPreview: false)
	}

	override init!(frame: NSRect, isPreview: Bool) {
		motivationLevel = Preferences().motivationLevel
		super.init(frame: frame, isPreview: isPreview)
		initialize()
	}

	required init?(coder: NSCoder) {
		motivationLevel = Preferences().motivationLevel
		super.init(coder: coder)
		initialize()
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	

	// MARK: - NSView

	override func drawRect(rect: NSRect) {
		let backgroundColor: NSColor = .blackColor()

		backgroundColor.setFill()
		NSBezierPath.fillRect(bounds)
	}

	// If the screen saver changes size, update the font
	override func resizeWithOldSuperviewSize(oldSize: NSSize) {
		super.resizeWithOldSuperviewSize(oldSize)
		updateFont()
	}


	// MARK: - ScreenSaverView

	override func animateOneFrame() {
		if let birthday = birthday {
			let age = ageForBirthday(birthday)
			let format = "%0.\(motivationLevel.decimalPlaces)f"
			textLabel.stringValue = String(format: format, age)
		} else {
			textLabel.stringValue = "Open Screen Saver Options to set your birthday."
		}
	}

	override func hasConfigureSheet() -> Bool {
		return true
	}

	override func configureSheet() -> NSWindow? {
		return configurationWindowController.window
	}
	

	// MARK: - Private

	/// Shared initializer
	private func initialize() {
		// Set animation time interval
		animationTimeInterval = 1 / 30

		// Recall preferences
		birthday = Preferences().birthday

		// Setup the label
		addSubview(textLabel)
		addConstraints([
			NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
		])

		// Listen for configuration changes
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "motivationLevelDidChange:", name: Preferences.motivationLevelDidChangeNotificationName, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "birthdayDidChange:", name: Preferences.birthdayDidChangeNotificationName, object: nil)
	}

	/// Age calculation
	private func ageForBirthday(birthday: NSDate) -> Double {
		let calendar = NSCalendar.currentCalendar()
		let now = NSDate()

		// An age is defined as the number of years you've been alive plus the number of days, seconds, and nanoseconds
		// you've been alive out of that many units in the current year.
		let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Day, NSCalendarUnit.Second, NSCalendarUnit.Nanosecond], fromDate: birthday, toDate: now, options: [])

		// We calculate these every time since the values can change when you cross a boundary. Things are too
		// complicated to try to figure out when that is and cache them. NSCalendar is made for this.
		let daysInYear = Double(calendar.daysInYear(now) ?? 365)
		let hoursInDay = Double(calendar.rangeOfUnit(NSCalendarUnit.Hour, inUnit: NSCalendarUnit.Day, forDate: now).length)
		let minutesInHour = Double(calendar.rangeOfUnit(NSCalendarUnit.Minute, inUnit: NSCalendarUnit.Hour, forDate: now).length)
		let secondsInMinute = Double(calendar.rangeOfUnit(NSCalendarUnit.Second, inUnit: NSCalendarUnit.Minute, forDate: now).length)
		let nanosecondsInSecond = Double(calendar.rangeOfUnit(NSCalendarUnit.Nanosecond, inUnit: NSCalendarUnit.Second, forDate: now).length)

		// Now that we have all of the values, assembling them is easy. We don't get minutes and hours from the calendar
		// since it will overflow nicely to seconds. We need days and years since the number of days in a year changes
		// more frequently. This will handle leap seconds, days, and years.
		let seconds = Double(components.second) + (Double(components.nanosecond) / nanosecondsInSecond)
		let minutes = seconds / secondsInMinute
		let hours = minutes / minutesInHour
		let days = Double(components.day) + (hours / hoursInDay)
		let years = Double(components.year) + (days / daysInYear)

		return years
	}

	/// Motiviation level changed
	@objc private func motivationLevelDidChange(notification: NSNotification?) {
		motivationLevel = Preferences().motivationLevel
	}

	/// Birthday changed
	@objc private func birthdayDidChange(notification: NSNotification?) {
		birthday = Preferences().birthday
	}

	/// Update the font for the current size
	private func updateFont() {
		if birthday != nil {
			textLabel.font = fontWithSize(bounds.width / 10)
		} else {
			textLabel.font = fontWithSize(bounds.width / 30, monospace: false)
		}
	}

	/// Get a font
	private func fontWithSize(fontSize: CGFloat, monospace: Bool = true) -> NSFont {
		let font: NSFont
		if #available(OSX 10.11, *) {
			font = .systemFontOfSize(fontSize, weight: NSFontWeightThin)
		} else {
			font = NSFont(name: "HelveticaNeue-Thin", size: fontSize)!
		}

		let fontDescriptor: NSFontDescriptor
		if monospace {
			fontDescriptor = font.fontDescriptor.fontDescriptorByAddingAttributes([
				NSFontFeatureSettingsAttribute: [
					[
						NSFontFeatureTypeIdentifierKey: kNumberSpacingType,
						NSFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector
					]
				]
			])
		} else {
			fontDescriptor = font.fontDescriptor
		}

		return NSFont(descriptor: fontDescriptor, size: fontSize)!
	}
}
