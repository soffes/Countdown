//
//  CountdownView.swift
//  Countdown
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class CountdownView: ScreenSaverView {

	// MARK: - Properties

	private let placeholderLabel: Label = {
		let view = Label()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.stringValue = "Open Screen Saver Options to set your date."
		return view
	}()

	private let daysView: PlaceView = {
		let view = PlaceView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.detailTextLabel.stringValue = "DAYS"
		return view
	}()

	private let hoursView: PlaceView = {
		let view = PlaceView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.detailTextLabel.stringValue = "HOURS"
		return view
	}()

	private let minutesView: PlaceView = {
		let view = PlaceView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.detailTextLabel.stringValue = "MINUTES"
		return view
	}()

	private let secondsView: PlaceView = {
		let view = PlaceView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.detailTextLabel.stringValue = "SECONDS"
		return view
	}()

	private let placesView: NSStackView = {
		let view = NSStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private lazy var configurationWindowController: NSWindowController = {
		return ConfigurationWindowController()
	}()

	private var date: NSDate? {
		didSet {
			updateFonts()
		}
	}


	// MARK: - Initializers

	convenience init() {
		self.init(frame: CGRectZero, isPreview: false)
	}

	override init!(frame: NSRect, isPreview: Bool) {
		super.init(frame: frame, isPreview: isPreview)
		initialize()
	}

	required init?(coder: NSCoder) {
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
		updateFonts()
	}


	// MARK: - ScreenSaverView

	override func animateOneFrame() {
		placeholderLabel.hidden = date != nil
		placesView.hidden = !placeholderLabel.hidden

		guard let date = date else { return }

		let units: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
		let now = NSDate()
		let components = NSCalendar.currentCalendar().components(units, fromDate: now, toDate: date, options: [])

		daysView.textLabel.stringValue = String(format: "%02d", components.day)
		hoursView.textLabel.stringValue = String(format: "%02d", components.hour)
		minutesView.textLabel.stringValue = String(format: "%02d", components.minute)
		secondsView.textLabel.stringValue = String(format: "%02d", components.second)
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
		date = Preferences().date

		// Setup the views
		addSubview(placeholderLabel)

		placesView.addArrangedSubview(daysView)
		placesView.addArrangedSubview(hoursView)
		placesView.addArrangedSubview(minutesView)
		placesView.addArrangedSubview(secondsView)
		addSubview(placesView)

		addConstraints([
			placeholderLabel.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
			placeholderLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor),

			placesView.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
			placesView.centerYAnchor.constraintEqualToAnchor(centerYAnchor)
		])

		// Listen for configuration changes
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dateDidChange), name: Preferences.dateDidChangeNotificationName, object: nil)
	}

	/// Age calculation
	private func ageFordate(date: NSDate) -> Double {
		return 0
	}

	/// date changed
	@objc private func dateDidChange(notification: NSNotification?) {
		date = Preferences().date
	}

	/// Update the font for the current size
	private func updateFonts() {
		placesView.spacing = max(32, round(bounds.width * 0.05))

		placeholderLabel.font = fontWithSize(round(bounds.width / 30), monospace: false)

		let places = [daysView, hoursView, minutesView, secondsView]
		let textFont = fontWithSize(round(bounds.width / 8), weight: NSFontWeightUltraLight)
		let detailTextFont = fontWithSize(round(bounds.width / 38), weight: NSFontWeightThin)

		for place in places {
			place.textLabel.font = textFont
			place.detailTextLabel.font = detailTextFont
		}
	}

	/// Get a font
	private func fontWithSize(fontSize: CGFloat, weight: CGFloat = NSFontWeightThin, monospace: Bool = true) -> NSFont {
		let font = NSFont.systemFontOfSize(fontSize, weight: weight)

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
