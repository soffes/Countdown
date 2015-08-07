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

	let textLabel: NSTextField = {
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

	lazy var configurationWindowController: NSWindowController = {
		return ConfigurationWindowController()
	}()


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


	// MARK: - NSView

	override func drawRect(rect: NSRect) {
		let backgroundColor: NSColor = .blackColor()

		backgroundColor.setFill()
		NSBezierPath.fillRect(bounds)

		if Preferences().birthday != nil {
			textLabel.font = .systemFontOfSize(bounds.width / 10)
		} else {
			textLabel.font = .systemFontOfSize(bounds.width / 30)
		}
	}


	// MARK: - ScreenSaverView

	override func animateOneFrame() {
		if let birthday = Preferences().birthday {
			let age = birthday.timeIntervalSinceNow * -1 / 60 / 60 / 24 / 365
			textLabel.stringValue = String(NSString(format: "%0.9f", age))
		} else {
			textLabel.stringValue = "Open Screen Saver Options to set your birthday."
		}
	}

	override func hasConfigureSheet() -> Bool {
		return true
	}

	override func configureSheet() -> NSWindow! {
		return configurationWindowController.window
	}
	

	// MARK: - Private

	private func initialize() {
		setAnimationTimeInterval(1 / 30)

		addSubview(textLabel)
		addConstraints([
			NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
		])
	}
}
