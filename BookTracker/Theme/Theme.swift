////
//  Theme.swift
//  BookTracker
//
//  Created by thislooksfun on 12/15/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit

struct ThemePair {
	let background: UIColor?
	let text: UIColor?
	
	static let `default` = ThemePair(background: nil, text: nil)
}

enum Theme: Int {
	case light
	case dark
	
	var `default`: ThemePair {
		switch self {
		case .light: return .default
		case .dark:  return ThemePair(background: UIColor.black, text: UIColor.white)
		}
	}
	
	var tableHeader: ThemePair {
		switch self {
		case .light: return .default
		case .dark:  return ThemePair(background: UIColor.darkGray, text: UIColor.white)
		}
	}
	
	var navBar: UIBarStyle {
		switch self {
		case .light: return .default
		case .dark:  return .black
		}
	}
	var statusBar: UIStatusBarStyle {
		switch self {
		case .light: return .default
		case .dark: return .lightContent
		}
	}
	var tint: UIColor {
		return ThemeManager.defaultTint
	}
}
