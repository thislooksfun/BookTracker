////
//  DetailViewController.swift
//  BookTracker
//
//  Created by thislooksfun on 12/14/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

class DetailViewController: ThemedViewController {
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var authorLabel: UILabel!
	@IBOutlet var progressLabel: UILabel!
	@IBOutlet var timeRemainingLabel: UILabel!
	@IBOutlet var nextPageLabel: UILabel!
	
	func configureView() {
		// Update the user interface for the detail item.
		guard let b = book,
			  titleLabel != nil
			  else {
			return
		}
		
		self.title = b.title
		
		titleLabel.text = b.title
		authorLabel.text = b.author?.fullName ?? "[Invalid author: nil]"
		let pagesRead = b.pagesRead
		progressLabel.text = "\(pagesRead)/\(b.length) : \(b.progress.percentString(places: 1))"
		
		if let timeLeft = b.timeRemaining {
			timeRemainingLabel.text = timeLeft.dynamicTimeFormat
		} else {
			timeRemainingLabel.text = "Not enough data to display time remaining"
		}
		
		nextPageLabel.text = "Next page: \(b.nextPage)"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "startSession" {
			let sessionController = segue.destination as! ReadingSessionController
			sessionController.book = book
		}
	}

	var book: Book? {
		didSet {
		    configureView()
		}
	}
}
