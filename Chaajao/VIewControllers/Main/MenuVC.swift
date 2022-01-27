//
//  MenuVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 10/09/2021.
//

import Foundation
import UIKit

class MenuVC : BaseCustomController {

    @IBOutlet weak var profileImageView: BaseUIImageView!
    @IBOutlet weak var usernameLabel: BaseUILabel!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        self.profileImageView.backgroundColor = .clear
        print(UserPreferences.shared().userModelData?.profileImage ?? "")
        self.profileImageView.kf.setImage(with: URL(string: UserPreferences.shared().userModelData?.profileImage ?? ""))
	}

    override func viewWillAppear(_ animated: Bool) {
        self.usernameLabel.text = "\(salutation) \(UserPreferences.shared().userModelData?.name ?? "")"
		super.viewWillAppear(animated)
	}
	func logout() {
		APP_DELEGATE.navController.setViewControllers([SignInVC.instantiate(fromAppStoryboard: .userAccess)], animated: false)
        UserPreferences.shared().clearAllOnLogout()
	}
	func navToCourses() {
		let coursesVc = CoursesVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(coursesVc, animated: true)
	}

	func navToProfile() {
		let profileVc = ProfileVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(profileVc, animated: true)
	}

	func navToBookmarks() {
		let bookmarksVc = BookmarksListVC.instantiate(fromAppStoryboard: .bookmarks)
		APP_DELEGATE.navController.pushViewController(bookmarksVc, animated: true)
	}

	func navToNotifications() {
		let vc = NotificationsVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}

	func navToContactUsVc() {
		let vc = ContactUsVC.instantiate(fromAppStoryboard: .main)
        vc.viewModel = ContactUsViewModel()
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}
}

extension MenuVC  {
	@IBAction func itemTapped(_ sender: AnyObject) {
		if let btn = sender as? UIButton {
			switch btn.accessibilityIdentifier {
				case "profile":
					navToProfile()
				case "chat":
					print("\(btn.accessibilityIdentifier ?? "") Screen n/a")
				case "news":
					navToNotifications()
				case "courses":
					navToCourses()
				case "bookmarks":
					navToBookmarks()
				case "share":
					shareApp()
				case "contactus":
					navToContactUsVc()
				case "tnc":
					print("\(btn.accessibilityIdentifier ?? "") Screen n/a")
				case "logout":
					logout()
				default: break
			}
		}
	}
}
