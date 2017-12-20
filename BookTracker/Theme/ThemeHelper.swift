////
//  ThemeHelper.swift
//  BookTracker
//
//  Created by thislooksfun on 12/15/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

protocol ThemedItem {
	func applyTheme()
	func listenForThemeChange()
	func apply(theme: Theme)
}
extension ThemedItem {
	func apply(theme: Theme) {}
}

// MARK: - ViewControllers -

protocol ThemedController: ThemedItem {
	var psbs: UIStatusBarStyle { get set }
}


open class ThemedViewController: UIViewController, ThemedController {
	var psbs = UIStatusBarStyle.default
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return psbs
	}
	
	@objc func applyTheme() {
		ThemeManager.applyTheme(self)
	}
	func listenForThemeChange() {
		NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("ThemeChange"), object: nil)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		applyTheme()
		listenForThemeChange()
	}
}
open class ThemedNavController: UINavigationController, ThemedController {
	var psbs = UIStatusBarStyle.default
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return psbs
	}
	
	@objc func applyTheme() {
		ThemeManager.applyTheme(self)
	}
	func listenForThemeChange() {
		NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("ThemeChange"), object: nil)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		applyTheme()
		listenForThemeChange()
	}
}
open class ThemedSplitViewController: UISplitViewController, ThemedController {
	var psbs = UIStatusBarStyle.default
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return psbs
	}
	
	@objc func applyTheme() {
		ThemeManager.applyTheme(self)
	}
	func listenForThemeChange() {
		NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("ThemeChange"), object: nil)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		applyTheme()
		listenForThemeChange()
	}
}
open class ThemedTableViewController: UITableViewController, ThemedController {
	var psbs = UIStatusBarStyle.default
	override open var preferredStatusBarStyle: UIStatusBarStyle {
		return psbs
	}
	
	@objc func applyTheme() {
		ThemeManager.applyTheme(self)
		self.tableView.reloadData()
	}
	func listenForThemeChange() {
		NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("ThemeChange"), object: nil)
	}
	func apply(theme: Theme) {
		self.tableView.backgroundColor = theme.default.background
		self.tableView.backgroundView?.backgroundColor = theme.default.background
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		applyTheme()
		listenForThemeChange()
	}
	
//	override open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//		let headerTheme = ThemeManager.current.tableHeader
//
//		let header = view as! UITableViewHeaderFooterView
//		header.contentView.backgroundColor = headerTheme.background
//		header.textLabel?.textColor = headerTheme.text
//	}
}

// MARK: - Views -

protocol ThemedView: ThemedItem {
}

open class ThemedTableViewCell: UITableViewCell, ThemedView {
	@objc func applyTheme() {
		ThemeManager.applyTheme(self)
	}
	func listenForThemeChange() {
		NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: NSNotification.Name("ThemeChange"), object: nil)
	}
	func apply(theme: Theme) {
		self.contentView.backgroundColor = theme.default.background
		self.backgroundView?.backgroundColor = theme.default.background
		
		self.textLabel?.textColor = theme.default.text
		self.detailTextLabel?.textColor = theme.default.text
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		applyTheme()
		listenForThemeChange()
	}
}
