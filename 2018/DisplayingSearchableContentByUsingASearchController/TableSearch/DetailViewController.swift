/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The detail view controller navigated to from our main and results table.
*/

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Constants

    // Constants for Storyboard/ViewControllers.
    private static let storyboardName = "MainStoryboard"
    private static let viewControllerIdentifier = "DetailViewController"
    
    // Constants for state restoration.
    private static let restoreProduct = "restoreProductKey"
    
    // MARK: - Properties

    var product: Product!
    
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    // MARK: - Initialization
    
    class func detailViewControllerForProduct(_ product: Product) -> UIViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)

        let viewController =
			storyboard.instantiateViewController(withIdentifier: DetailViewController.viewControllerIdentifier)
		
		if let detailViewController = viewController as? DetailViewController {
        	detailViewController.product = product
		}
		
        return viewController
    }
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        title = product.title
        
        yearLabel.text = "\(product.yearIntroduced)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.formatterBehavior = .default
        let priceString = numberFormatter.string(from: NSNumber(value: product.introPrice))
        priceLabel.text = priceString
    }
	
}

// MARK: - UIStateRestoration

extension DetailViewController {
	
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		
		// Encode the product.
		coder.encode(product, forKey: DetailViewController.restoreProduct)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		
		// Restore the product.
		if let decodedProduct = coder.decodeObject(forKey: DetailViewController.restoreProduct) as? Product {
			product = decodedProduct
		} else {
			fatalError("A product did not exist. In your app, handle this gracefully.")
		}
	}
	
}
