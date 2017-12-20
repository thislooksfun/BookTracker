////
//  Author.swift
//  BookTracker
//
//  Created by thislooksfun on 12/16/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

extension Author {
	var fullName: String {
		guard let first = firstName,
			let last = lastName
			else {
				return "[Invalid author: missing name]"
		}
		return "\(first) \(last)"
	}
}
