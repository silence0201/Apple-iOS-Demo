/*
	Copyright (C) 2015 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	This file contains the OnDemandRuleListController class, which is responsible for controlling a list of Connect On Demand rules.
*/

import UIKit
import NetworkExtension

/// A view controller for a view displaying a list of Connect On Demand rules.
class OnDemandRuleListController: ListViewController {

	// MARK: Properties

	/// The VPN configuration containing the Connect On Demand rules.
	var targetManager: NEVPNManager = NEVPNManager.sharedManager()

	/// The text to display in the list's "add new item" row.
	override var listAddButtonText: String {
		return "Add On Demand Rule..."
	}

	/// The number of Connect On Demand rules.
	override var listCount: Int {
		return targetManager.onDemandRules?.count ?? 0
	}

	/// Returns UITableViewCellAccessoryType.DetailButton
	override var listAccessoryType: UITableViewCellAccessoryType {
		return .DetailButton
	}

	/// Returns UITableViewCellAccessoryType.DetailButton
	override var listEditingAccessoryType: UITableViewCellAccessoryType {
		return .DetailButton
	}

	// MARK: UIViewController

	/// Handle the event when the view is loaded into memory.
	override func viewDidLoad() {
		isAddEnabled = true
		isAlwaysEditing = true
		super.viewDidLoad()
	}

	// MARK: Interface

	/// Handle unwind segues to this view controller.
	@IBAction func handleUnwind(sender: UIStoryboardSegue) {
	}

	// MARK: ListViewController

	/// Set up the destination view controller of a segue away from this view controller.
	override func listSetupSegue(segue: UIStoryboardSegue, forItemAtIndex index: Int) {
		guard let identifier = segue.identifier,
			ruleAddEditController = segue.destinationViewController as? OnDemandRuleAddEditController
			else { return }

		switch identifier {
			case "edit-on-demand-rule":
				// The user tapped on the editing accessory of a rule in the list.
				guard let rule = targetManager.onDemandRules?[index] else { break }
				ruleAddEditController.setTargetRule(rule, title: "On Demand Rule") { newRule in
					self.targetManager.onDemandRules?[index] = newRule
				}

			case "add-on-demand-rule":
				// The user tapped on the "add a new rule" row.
				ruleAddEditController.setTargetRule(nil, title: "Add On Demand Rule") { newRule in
					if self.targetManager.onDemandRules == nil {
						self.targetManager.onDemandRules = [NEOnDemandRule]()
					}
					self.targetManager.onDemandRules?.append(newRule)
				}

			default:
				break
		}
	}

	/// Return a description of the rule at the given index in the list.
	override func listTextForItemAtIndex(index: Int) -> String {
		return targetManager.onDemandRules?[index].action.description ?? ""
	}

	/// Remove a rule from the list.
	override func listRemoveItemAtIndex(index: Int) {
		targetManager.onDemandRules?.removeAtIndex(index)
	}
}
