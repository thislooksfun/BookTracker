////
//  AddBookController.swift
//  BookTracker
//
//  Created by thislooksfun on 12/14/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

class AddBookController: ThemedViewController, UITextFieldDelegate {
	
	@IBOutlet var contentView: UIView!
	
	@IBOutlet var titleField: UITextField!
	@IBOutlet var firstPageField: UITextField!
	@IBOutlet var lastPageField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.preferredContentSize.height = contentView.frame.height
		
		if ThemeManager.current == .light {
			ThemeManager.current = .dark
		} else {
			ThemeManager.current = .light
		}
		
		self.titleField.becomeFirstResponder()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction
	func add(_ sender: Any? = nil) {
		guard let title = titleField.text,
			  let fp = firstPageField.text,
			  let firstPage = Int16(fp),
			  let lp = lastPageField.text,
			  let lastPage = Int16(lp) else {
			shake()
			return
		}
		
		let newBook = Book.make()
		
		newBook.title = title
		newBook.firstPage = firstPage
		newBook.lastPage = lastPage
		
		// Save the context.
		CDHelper.save()
		self.dismiss(animated: true, completion: nil)
	}
	
	func shake() {
		guard let supView = self.view.superview?.superview else {
			return
		}
		let frame = supView.frame
		
		let animation = CABasicAnimation(keyPath: "position")
		animation.duration = 0.06
		animation.repeatCount = 2
		animation.autoreverses = true
		animation.fromValue = CGPoint(x: frame.midX - 10, y: frame.midY)
		animation.toValue = CGPoint(x: frame.midX + 10, y: frame.midY)
		
		supView.layer.add(animation, forKey: "position")
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
		case titleField.tag: firstPageField.becomeFirstResponder()
		case firstPageField.tag: lastPageField.becomeFirstResponder()
		case lastPageField.tag: add()
		default:
			textField.resignFirstResponder()
			return true
		}
		
		return false
	}
}
