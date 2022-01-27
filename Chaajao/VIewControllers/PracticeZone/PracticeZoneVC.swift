//
//  PracticeZoneVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 16/09/2021.
//

class PracticeZoneVC: BaseCustomController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	func navToBuyThisCourse() {
		APP_DELEGATE.navController.popToRootViewController(animated: false)
		let practiceZoneBuyPackageVC =
			PracticeZoneBuyPackageVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(practiceZoneBuyPackageVC, animated: true)
	}
}

//MARK: IBActions
extension PracticeZoneVC {

	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func buyThisCourse() {
		navToBuyThisCourse()
	}
}
