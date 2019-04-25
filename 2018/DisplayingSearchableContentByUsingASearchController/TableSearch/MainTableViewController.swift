/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application's primary table view controller showing a list of products.
*/

import UIKit

class MainTableViewController: BaseTableViewController {
    
    // MARK: - Types
    
    /// State restoration values.
    private enum RestorationKeys: String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    /// NSPredicate expression keys.
    private enum ExpressionKeys: String {
        case title
        case yearIntroduced
        case introPrice
    }
    
    private struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    // MARK: - Properties
    
    /// Data model for the table view.
    var products = [Product]()
    
    /** The following 2 properties are set in viewDidLoad(),
        They are implicitly unwrapped optionals because they are used in many other places
		throughout this view controller.
    */
    
    /// Search controller to help us with filtering.
    private var searchController: UISearchController!
    
    /// Secondary search results table view.
    private var resultsTableController: ResultsTableController!
    
    /// Restoration state for UISearchController
    private var restoredState = SearchControllerRestorableState()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        resultsTableController = ResultsTableController()

        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, place the search bar in the navigation bar.
            navigationItem.searchController = searchController
            
            // Make the search bar always visible.
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
            tableView.tableHeaderView = searchController.searchBar
        }
		
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // The default is true.
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        /** Search presents a view controller by applying normal view controller presentation semantics.
            This means that the presentation moves up the view controller hierarchy until it finds the root
            view controller or one that defines a presentation context.
        */
        
        /** Specify that this view controller determines how the search controller is presented.
            The search controller should be presented modally and match the physical size of this view controller.
        */
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Restore the searchController's active state.
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct: Product
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedProduct = products[indexPath.row]
        } else {
            selectedProduct = resultsTableController.filteredProducts[indexPath.row]
        }
        
        // Set up the detail view controller to show.
        let detailViewController = DetailViewController.detailViewControllerForProduct(selectedProduct)

        navigationController?.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension MainTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return products.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
		
		let product = products[indexPath.row]
		configureCell(cell, forProduct: product)
		
		return cell
	}
	
}

// MARK: - UISearchBarDelegate

extension MainTableViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension MainTableViewController: UISearchControllerDelegate {
	
	func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
}

// MARK: - UISearchResultsUpdating

extension MainTableViewController: UISearchResultsUpdating {
	
	private func findMatches(searchString: String) -> NSCompoundPredicate {
		/** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            Example if searchItems contains "Gladiolus 51.99 2001":
                name CONTAINS[c] "gladiolus"
                name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
                name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
		*/
		var searchItemsPredicate = [NSPredicate]()
		
		/** Below we use NSExpression represent expressions in our predicates.
		    NSPredicate is made up of smaller, atomic parts:
            two NSExpressions (a left-hand value and a right-hand value).
		*/
        
		// Name field matching.
		let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
		let searchStringExpression = NSExpression(forConstantValue: searchString)
		
		let titleSearchComparisonPredicate =
			NSComparisonPredicate(leftExpression: titleExpression,
								  rightExpression: searchStringExpression,
								  modifier: .direct,
								  type: .contains,
								  options: [.caseInsensitive, .diacriticInsensitive])
		
		searchItemsPredicate.append(titleSearchComparisonPredicate)
		
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .none
		numberFormatter.formatterBehavior = .default
		
		// The `searchString` may fail to convert to a number.
        if let targetNumber = numberFormatter.number(from: searchString) {
			// Use `targetNumberExpression` in both the following predicates.
			let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
			
			// The `yearIntroduced` field matching.
            let yearIntroducedExpression = NSExpression(forKeyPath: ExpressionKeys.yearIntroduced.rawValue)
			let yearIntroducedPredicate =
				NSComparisonPredicate(leftExpression: yearIntroducedExpression,
									  rightExpression: targetNumberExpression,
									  modifier: .direct,
									  type: .equalTo,
									  options: [.caseInsensitive, .diacriticInsensitive])
			
			searchItemsPredicate.append(yearIntroducedPredicate)
			
			// The `price` field matching.
			let lhs = NSExpression(forKeyPath: ExpressionKeys.introPrice.rawValue)
			
			let finalPredicate =
				NSComparisonPredicate(leftExpression: lhs,
									  rightExpression: targetNumberExpression,
									  modifier: .direct,
									  type: .equalTo,
									  options: [.caseInsensitive, .diacriticInsensitive])
			
			searchItemsPredicate.append(finalPredicate)
		}
		
		let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
		
		return orMatchPredicate
	}
	
	func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = products

        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }

        // Match up the fields of the Product object.
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)

        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }

        // Apply the filtered results to the search results table.
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.filteredProducts = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
}

// MARK: - UIStateRestoration

extension MainTableViewController {
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		
		// Encode the view state so it can be restored later.
		
		// Encode the title.
		coder.encode(navigationItem.title!, forKey: RestorationKeys.viewControllerTitle.rawValue)

		// Encode the search controller's active state.
		coder.encode(searchController.isActive, forKey: RestorationKeys.searchControllerIsActive.rawValue)
		
		// Encode the first responser status.
		coder.encode(searchController.searchBar.isFirstResponder, forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
		
		// Encode the search bar text.
		coder.encode(searchController.searchBar.text, forKey: RestorationKeys.searchBarText.rawValue)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		
		// Restore the title.
		guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
			fatalError("A title did not exist. In your app, handle this gracefully.")
		}
		navigationItem.title! = decodedTitle
		
		/** Restore the active state:
			We can't make the searchController active here since it's not part of the view
			hierarchy yet, instead we do it in viewWillAppear.
		*/
		restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
		
		/** Restore the first responder status:
			Like above, we can't make the searchController first responder here since it's not part of the view
			hierarchy yet, instead we do it in viewWillAppear.
		*/
		restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
		
		// Restore the text in the search field.
		searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
	}
	
}
