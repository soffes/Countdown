//
//  ConfigurationWindowController.swift
//  Motivation
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import AppKit

class ConfigurationWindowController: NSWindowController {

	// MARK: - Properties

	override var windowNibName: String {
		return "Configuration"
	}


	// MARK: - Action

	@IBAction func close(sender: AnyObject?) {
		if let window = window {
			window.sheetParent?.endSheet(window)
		}
	}
}
