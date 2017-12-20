////
//  BookHelper.swift
//  BookTracker
//
//  Created by thislooksfun on 12/14/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit
import CoreData

extension Book {
	var length: Int16 {
		// Offset to account for the first page needing to be read
		// e.g.: firstPage(5) lastPage(10) is 6 pages (5,6,7,8,9,10)
		return lastPage - firstPage + 1
	}
	var pagesRead: Int16 {
		// Offset to account for the first page needing to be read
		// e.g.: firstPage(5) lastPageRead(10) is 6 pages (5,6,7,8,9,10)
		return lastPageRead - firstPage + 1
	}
	var pagesLeft: Int16 {
		return lastPage - pagesRead
	}
	var lastSession: Session? {
		let sorted = sessions?.sortedArray(using: [NSSortDescriptor(key: "endTime", ascending: true)])
		return sorted?.last as? Session
	}
	var lastPageRead: Int16 {
		guard let last = lastSession else {
			return firstPage - 1
		}
		return last.endPage
	}
	var nextPage: Int16 {
		return lastPageRead + 1
	}
	var progress: Float {
		guard sessions!.count > 0 else {
			return 0
		}
		return Float(pagesRead)/Float(length)
	}
	var timeRemaining: TimeInterval? {
		guard sessions!.count > 0 else {
			return nil
		}
		
		var pagesRead: Int16 = 0
		var timeTaken: TimeInterval = 0
		
		for obj in sessions! {
			let s = obj as! Session
			pagesRead += s.pages
			timeTaken += s.duration
		}
		
		let avgTimePerPage = Double(pagesRead)/timeTaken
		
		return avgTimePerPage * Double(pagesLeft)
	}
}
