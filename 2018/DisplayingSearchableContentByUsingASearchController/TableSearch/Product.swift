/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The data model object describing the product displayed in both main and results tables.
*/

import Foundation

class Product: NSObject, NSCoding {
    
    // MARK: - Types
    
    private enum CoderKeys: String {
        case nameKey
        case yearKey
        case priceKey
    }
    
    struct ProductKind {
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
	}

    // MARK: - Properties
    
    /** These properties need @objc to make them key value compliant when filtering using NSPredicate,
        and so they are accessible and usable in Objective-C to interact with other frameworks.
    */
    @objc let title: String
   	@objc let yearIntroduced: Int
   	@objc let introPrice: Double
    
    // MARK: - Initializers
    
    init(title: String, yearIntroduced: Int, introPrice: Double) {
        self.title = title
        self.yearIntroduced = yearIntroduced
        self.introPrice = introPrice
    }
    
    // MARK: - NSCoding
	
	/// This is called for UIStateRestoration
    required init?(coder aDecoder: NSCoder) {
		guard let decodedTitle = aDecoder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String else {
			fatalError("A title did not exist. In your app, handle this gracefully.")
		}
		title = decodedTitle
        yearIntroduced = aDecoder.decodeInteger(forKey: CoderKeys.yearKey.rawValue)
        introPrice = aDecoder.decodeDouble(forKey: CoderKeys.priceKey.rawValue)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: CoderKeys.nameKey.rawValue)
        aCoder.encode(yearIntroduced, forKey: CoderKeys.yearKey.rawValue)
        aCoder.encode(introPrice, forKey: CoderKeys.priceKey.rawValue)
    }
    
}
