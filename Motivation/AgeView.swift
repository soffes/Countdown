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
			let age = birthday.timeIntervalSinceNow * -1 / 60 / 60 / 24 / 365
			let format = "%0.\(motivationLevel.decimalPlaces)f"
			textLabel.stringValue = String(NSString(format: format, age))
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
