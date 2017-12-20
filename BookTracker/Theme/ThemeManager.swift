////
//  ThemeManager.swift
//  BookTracker
//
//  Created by thislooksfun on 12/15/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

struct ThemeManager {
	private static let selectedThemeKey = "SelectedTheme"
	private static var selectedTheme: Theme = {
		if let val = UserDefaults.standard.value(forKey: selectedThemeKey) as? Int {
			return Theme(rawValue: val) ?? .light
		} else {
			return .light
		}
	}()
	static var defaultTint: UIColor!
	
	static var current: Theme {
		get {
			return selectedTheme
		}
		set {
			print("Switching to \(newValue) theme")
			selectedTheme = newValue
			UserDefaults.standard.set(selectedTheme.rawValue, forKey: selectedThemeKey)
			NotificationCenter.default.post(name: NSNotification.Name("ThemeChange"), object: newValue)
		}
	}
	
	static func applyTheme(_ to: ThemedView & UIView) {
		//TODO: Fully implement
		return
		
//		print("Applying \(current) theme to \(to)")
//
//		to.backgroundColor = current.default.background
//		to.apply(theme: current)
	}
	static func applyTheme(_ to: ThemedController & UIViewController) {
		//TODO: Fully implement
		return
		
//		print("Applying \(current) theme to \(to)")
//		var vc = to
//
//		// Apply global traits
//		vc.view.backgroundColor = current.default.background
//		vc.navigationController?.navigationBar.barStyle = current.navBar
//		vc.psbs = current.statusBar
//		vc.setNeedsStatusBarAppearanceUpdate()
//
//		// Apply specific changes
//		vc.apply(theme: current)
	}
}
