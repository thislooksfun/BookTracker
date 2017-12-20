////
//  Pause.swift
//  BookTracker
//
//  Created by thislooksfun on 12/16/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

extension Pause {
	var duration: TimeInterval {
		return end!.timeIntervalSince(start!)
	}
}
