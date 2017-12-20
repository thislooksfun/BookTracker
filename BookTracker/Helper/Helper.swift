////
//  Helper.swift
//  BookTracker
//
//  Created by thislooksfun on 12/14/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import Foundation

// MARK - Numbers -
protocol MinMax {
	static var min: Self { get }
	static var max: Self { get }
}

extension Int:   MinMax {}
extension Int8:  MinMax {}
extension Int16: MinMax {}
extension Int32: MinMax {}
extension Int64: MinMax {}
extension UInt:   MinMax {}
extension UInt8:  MinMax {}
extension UInt16: MinMax {}
extension UInt32: MinMax {}
extension UInt64: MinMax {}


extension Numeric where Self: Comparable {
	func clamp(min: Self, max: Self) -> Self {
		if (self < min) { return min }
		if (self > max) { return max }
		return self
	}
	func within(min: Self, max: Self) -> Bool {
		return self >= min && self <= max
	}
}
extension Numeric where Self: Comparable & MinMax {
	func clamp(min: Self = Self.min, max: Self = Self.max) -> Self {
		if (self < min) { return min }
		if (self > max) { return max }
		return self
	}
}

extension Float {
	var percent: Float { return self * 100 }
	
	func percentString(places: UInt = 0) -> String {
		return String(format: "%.\(places)f%%", percent)
	}
}
extension Double {
	var percent: Double { return self * 100 }
	
	func percentString(places: UInt = 0) -> String {
		return String(format: "%.\(places)f%%", percent)
	}
}

extension TimeInterval {
	var dynamicTimeFormat: String {
		
		let secPerMin: Double = 60
		let secPerHour: Double = secPerMin * 60
		let secPerDay: Double = secPerHour * 24
		
		let days = (self/secPerDay).rounded(.down)
		let hours = (self/secPerHour).truncatingRemainder(dividingBy: 24).rounded(.down)
		let minutes = (self/secPerMin).truncatingRemainder(dividingBy: 60).rounded(.down)
		let seconds = self.truncatingRemainder(dividingBy: 60).rounded(.down)
		
		if days > 0 {
			return String(format: "%.0fd %2.0fh %2.0fm %2.0fs", arguments: [days, hours, minutes, seconds])
//			return "\(days)d \(hours)h \(minutes)m \(seconds)s"
		} else if hours > 0 {
			return String(format: "%.0fh %02.0fm %02.0fs", arguments: [hours, minutes, seconds])
//			return "\(hours)h \(minutes)m \(seconds)s"
		} else {
			return String(format: "%.0fm %02.0fs", arguments: [minutes, seconds])
//			return "\(minutes)m \(seconds)s"
		}
	}
}

// MARK: - String -
extension String {
	var isAlphanumeric: Bool {
		return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
	}
	var isAlpha: Bool {
		return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
	}
	var isNumeric: Bool {
		return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
	}
}

// MARK: - NSString -
extension NSString {
	@objc
	func stringGroupByFirstInitial() -> NSString {
		if (self.length <= 1) {
			return self
		}
		let firstChar = self.substring(to: 1)
		if firstChar.isAlpha {
			return NSString(string: firstChar)
		} else {
			return "#"
		}
	}
	@objc
	func stringGroupByLowercasedFirstInitial() -> NSString {
		return NSString(string: stringGroupByFirstInitial().lowercased)
	}
}
