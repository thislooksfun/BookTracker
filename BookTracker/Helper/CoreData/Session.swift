////
//  Session.swift
//  BookTracker
//
//  Created by thislooksfun on 12/16/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

extension Session {
	var pages: Int16 {
		return endPage - startPage
	}
	var duration: TimeInterval {
		var time = endTime!.timeIntervalSince(startTime!)
		for obj in pauses! {
			let p = obj as! Pause
			time -= p.duration
		}
		return time
	}
}
