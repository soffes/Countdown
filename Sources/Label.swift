//
//  Label.swift
//  Countdown
//
//  Created by Sam Soffes on 3/21/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
//

import AppKit

final class Label: NSTextField {
	override init(frame: NSRect) {
		super.init(frame: frame)
		editable = false
		drawsBackground = false
		bordered = false
		bezeled = false
		selectable = false
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
