/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The application delegate class used for setting up our data model and state restoration.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    /** The app delegate must implement the window from UIApplicationDelegate
        protocol to use a main storyboard file.
    */
    var window: UIWindow?
    
    // MARK: - Application Life Cycle

    static let Ginger = "Ginger"
    static let Gladiolus = "Gladiolus"
    static let Orchid = "Orchid"
    static let Poinsettia = "Poinsettia"
    static let RedRose = "Red Rose"
    static let WhiteRose = "White Rose"
    static let Tulip = "Tulip"
    static let Carnation = "Carnation"
    static let Sunflower = "Sunflower"
    static let Gardenia = "Gardenia"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let products = [
            Product(title: Product.ProductKind.Ginger, yearIntroduced: 2007, introPrice: 49.98),
            Product(title: Product.ProductKind.Gladiolus, yearIntroduced: 2001, introPrice: 51.99),
            Product(title: Product.ProductKind.Orchid, yearIntroduced: 2007, introPrice: 16.99),
            Product(title: Product.ProductKind.Poinsettia, yearIntroduced: 2010, introPrice: 31.99),
            Product(title: Product.ProductKind.RedRose, yearIntroduced: 2010, introPrice: 24.99),
            Product(title: Product.ProductKind.WhiteRose, yearIntroduced: 2012, introPrice: 24.99),
            Product(title: Product.ProductKind.Tulip, yearIntroduced: 1997, introPrice: 39.99),
            Product(title: Product.ProductKind.Carnation, yearIntroduced: 2006, introPrice: 23.99),
            Product(title: Product.ProductKind.Sunflower, yearIntroduced: 2008, introPrice: 25.00),
            Product(title: Product.ProductKind.Gardenia, yearIntroduced: 2006, introPrice: 25.00)
        ]

		if let navController = window!.rootViewController as? UINavigationController {
			/** Note we want the first view controller (not the visibleViewController) in case
				we are being restored from UIStateRestoration.
			*/
			if let tableViewController = navController.viewControllers.first as? MainTableViewController {
				tableViewController.products = products
			}
		}

        return true
    }

    // MARK: - UIStateRestoration

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
