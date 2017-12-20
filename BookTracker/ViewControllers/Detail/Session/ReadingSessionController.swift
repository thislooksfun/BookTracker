////
//  ReadingSessionController.swift
//  BookTracker
//
//  Created by thislooksfun on 12/16/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

private struct Section {
	let start: Date
	let end: Date
	
	var msTime: TimeInterval {
		return end.timeIntervalSince(start)
	}
}
extension Array where Element == Section {
	var totalTime: TimeInterval {
		var t: TimeInterval = 0
		for e in self {
			t += e.msTime
		}
		return t
	}
}

class ReadingSessionController: ThemedViewController {
	
	private var msTimeInSections: TimeInterval = 0
	private var sections: [Section] = []
	private var startTime: Date?
	
	private var timer: Timer?
	
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var pauseResumeButton: UIButton!
	
	var book: Book?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		resume()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func updateTime(_ timer: Timer) {
		var timeTaken = msTimeInSections
		if let st = startTime {
			timeTaken += Date().timeIntervalSince(st)
		}
		
		timeLabel.text = timeTaken.dynamicTimeFormat
	}
	
	func pause() {
		guard let st = startTime else {
			return
		}
		
		let section = Section(start: st, end: Date())
		sections.append(section)
		msTimeInSections += section.msTime
		startTime = nil
		
		timer?.invalidate()
		
		pauseResumeButton.setTitle("Resume", for: .normal)
	}
	func resume() {
		guard startTime == nil else {
			return
		}
		
		startTime = Date()
		
		timer = Timer(timeInterval: 0.25, repeats: true, block: updateTime)
		RunLoop.main.add(timer!, forMode: .commonModes)
		
		pauseResumeButton.setTitle("Pause", for: .normal)
	}
	
	@IBAction func pauseResume(_ sender: Any) {
		if startTime != nil {
			pause()
		} else {
			resume()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "finishSession" {
			pause() // Make sure it's stopped at the end
			
			let fsc = segue.destination as! FinishSessionController
			fsc.book = book
			fsc.sections = sections
			fsc.rsc = self
		}
 	}
}

class FinishSessionController: ThemedViewController, UITextFieldDelegate {
	fileprivate var sections: [Section] = []
	var book: Book?
	
	@IBOutlet var startLabel: UILabel!
	@IBOutlet var endLabel: UILabel!
	@IBOutlet var totalTimeLabel: UILabel!
	@IBOutlet var timeSpentReadingLabel: UILabel!
	@IBOutlet var lastPageReadField: UITextField!
	
	fileprivate var rsc: ReadingSessionController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let start = sections.first!.start
		let end = sections.last!.end
		
		startLabel.text = "Start: \(start)"
		endLabel.text = "End: \(end)"
		let totalTime = end.timeIntervalSince(start)
		totalTimeLabel.text = "Total Time: \(totalTime.dynamicTimeFormat)"
		let timeReading = sections.totalTime
		let percentTimeReading = timeReading/totalTime
		timeSpentReadingLabel.text = "Time Spent Reading: \(timeReading.dynamicTimeFormat) (\(percentTimeReading.percentString(places: 1)))"
		
		lastPageReadField.becomeFirstResponder()
	}
	
	@IBAction func close(_ sender: Any? = nil) {
		
		self.dismiss(animated: false) {
			self.rsc.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func save(_ sender: Any? = nil) {
		let newSession = Session.make()
		
		newSession.book = book
		newSession.startTime = sections.first!.start
		newSession.endTime = sections.last!.end
		
		newSession.startPage = book!.nextPage
		newSession.endPage = Int16(lastPageReadField.text!)!
		
		for i in 0..<sections.count-1 {
			let pause = Pause.make()
			pause.start = sections[i].end
			pause.end = sections[i+1].start
			newSession.addToPauses(pause)
		}
		
		// Save the context.
		CDHelper.save()
		close()
	}
	
	// MARK: - UITextFieldDelegate
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if string.count == 0 {
			return true
		}
		guard textField.keyboardType == .numberPad || textField.keyboardType == .decimalPad else {
			return true
		}
		
		let nonNumericsFound = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) != nil
		return !nonNumericsFound
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField.tag {
		case lastPageReadField.tag: save()
		default:
			textField.resignFirstResponder()
			return true
		}
		
		return false
	}
}
