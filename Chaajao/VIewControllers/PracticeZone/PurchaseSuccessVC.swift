//
//  PurchaseSuccessVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 21/09/2021.
//

import Foundation

class PurchaseSuccessVC : BaseCustomController {
	@IBOutlet weak var successView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

//MARK: IBActions
extension PurchaseSuccessVC {

	@IBAction func home() {
		APP_DELEGATE.navController.popToRootViewController(animated: true)
	}
	@IBAction func navToPracticeZone() {
		APP_DELEGATE.navController.popToRootViewController(animated: false)
		let practiceTestsVc = PracticeTestsVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(practiceTestsVc, animated: true)
	}
}
