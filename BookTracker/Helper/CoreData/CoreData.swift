////
//  CoreData.swift
//  BookTracker
//
//  Created by thislooksfun on 12/16/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit
import CoreData

protocol CDObject {}
extension CDObject {
	static var context: NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
}

struct CDHelper: CDObject {
	static func save() {
		do {
			try context.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}
}

protocol BetterManagedObject: CDObject {
	static func make() -> Self
}

extension NSManagedObject: BetterManagedObject {
	static func make() -> Self {
		return self.init(context: context)
	}
}
