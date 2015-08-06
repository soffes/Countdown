//
//  ViewController.swift
//  Preview
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let view = view as? ScreenSaverView {
			NSTimer.scheduledTimerWithTimeInterval(view.animationTimeInterval(), target: view, selector: "animateOneFrame", userInfo: nil, repeats: true)
		}
	}
}
