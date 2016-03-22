//
//  PlaceView.swift
//  Countdown
//
//  Created by Sam Soffes on 3/21/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import AppKit

final class PlaceView: NSView {

	// MARK: - Properties

	let textLabel: Label = {
		let label = Label()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .whiteColor()
		label.alignment = .Center
		return label
	}()

	let detailTextLabel: Label = {
		let label = Label()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = NSColor(white: 1, alpha: 0.5)
		label.alignment = .Center
		return label
	}()


	// MARK: - Initializers

	init() {
		super.init(frame: .zero)

		addSubview(textLabel)
		addSubview(detailTextLabel)

		NSLayoutConstraint.activateConstraints([
			textLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
			textLabel.topAnchor.constraintEqualToAnchor(topAnchor),
			textLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
			textLabel.bottomAnchor.constraintEqualToAnchor(detailTextLabel.topAnchor),
			detailTextLabel.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
			detailTextLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
			detailTextLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
