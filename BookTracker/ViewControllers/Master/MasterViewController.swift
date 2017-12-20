////
//  MasterViewController.swift
//  BookTracker
//
//  Created by thislooksfun on 12/14/17.
//  Copyright © 2017 thislooksfun. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: ThemedTableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate, UISearchResultsUpdating {
	
	var detailViewController: DetailViewController? = nil
	var managedObjectContext: NSManagedObjectContext? = nil
	
	override func viewDidLoad() {
//		ThemeManager.current = .dark
		super.viewDidLoad()
		ThemeManager.defaultTint = self.view.tintColor
		
		// Do any additional setup after loading the view, typically from a nib.
		navigationItem.leftBarButtonItem = editButtonItem
		
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		navigationItem.searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController?.searchResultsUpdater = self
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Segues
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		// Return no adaptive presentation style, use default presentation behaviour
		return .none
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = tableView.indexPathForSelectedRow {
		    	let object = fetchedResultsController.object(at: indexPath)
		        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
		        controller.book = object
		        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		} else if segue.identifier == "addBook" {
			let dest = segue.destination as! AddBookController
			dest.popoverPresentationController?.delegate = self
		}
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}
	
	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return ["#","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetchedResultsController.sections?[section].indexTitle
	}
	
	override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		guard let sections = fetchedResultsController.sections else {
			return 0
		}
		
		for (i, s) in sections.enumerated() {
			if s.name.caseInsensitiveCompare(title) != .orderedAscending {
				return i
			}
		}
		return 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let book = fetchedResultsController.object(at: indexPath)
		configureCell(cell, withBook: book)
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		    let context = fetchedResultsController.managedObjectContext
		    context.delete(fetchedResultsController.object(at: indexPath))
			
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

	func configureCell(_ cell: UITableViewCell, withBook book: Book) {
		cell.textLabel!.text = book.title!
		cell.detailTextLabel!.text = book.progress.percentString(places: 1)
	}

	// MARK: - Fetched results controller

	var fetchedResultsController: NSFetchedResultsController<Book> {
	    if _fetchedResultsController == nil {
			let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
			
			// Set the batch size to a suitable number.
			fetchRequest.fetchBatchSize = 20
			
			// Edit the sort key as appropriate.
			let sectionSortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
			fetchRequest.sortDescriptors = [sectionSortDescriptor]
			
			// Edit the section name key path and cache name if appropriate.
			// nil for section name key path means "no sections".
			let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "title.stringGroupByLowercasedFirstInitial", cacheName: "Master")
			aFetchedResultsController.delegate = self
			_fetchedResultsController = aFetchedResultsController
	    }
		
		if searchStringChanged {
			let fetchRequest = _fetchedResultsController!.fetchRequest
			
			if let ss = searchString {
				fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", ss)
			} else {
				fetchRequest.predicate = nil
			}
			
			NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: _fetchedResultsController!.cacheName)
			
			do {
				try _fetchedResultsController!.performFetch()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
		
	    return _fetchedResultsController!
	}    
	var _fetchedResultsController: NSFetchedResultsController<Book>? = nil

	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	    tableView.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
	    switch type {
	        case .insert:
	            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
	        case .delete:
	            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
	        default:
	            return
	    }
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
	    switch type {
	        case .insert:
	            tableView.insertRows(at: [newIndexPath!], with: .fade)
	        case .delete:
	            tableView.deleteRows(at: [indexPath!], with: .fade)
	        case .update:
	            configureCell(tableView.cellForRow(at: indexPath!)!, withBook: anObject as! Book)
	        case .move:
	            configureCell(tableView.cellForRow(at: indexPath!)!, withBook: anObject as! Book)
	            tableView.moveRow(at: indexPath!, to: newIndexPath!)
	    }
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
	    tableView.endUpdates()
	}

	/*
	 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
	 
	 func controllerDidChangeContent(controller: NSFetchedResultsController) {
	     // In the simplest, most efficient, case, reload the table view.
	     tableView.reloadData()
	 }
	 */
	
	
	// MARK: - UISearchResultsUpdating
	
	var searchString: String? = nil
	var searchStringChanged: Bool = true
	
	func updateSearchResults(for searchController: UISearchController) {
		searchString = searchController.searchBar.text
		searchStringChanged = true
		if let ss = searchString, ss.isEmpty {
			searchString = nil
		}
		tableView.reloadData()
	}
}
