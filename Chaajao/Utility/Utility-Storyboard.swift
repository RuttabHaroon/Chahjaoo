//
//  Utility-Storyboard.swift
//
//
//

import UIKit

enum AppStoryboard : String {


	case main = "Main"; case userAccess = "UserAccess"; case askYourDoubt = "AskYourDoubt"; case practiceZone = "PracticeZone"; case tests = "Tests"; case analytics = "Analytics"; case bookmarks = "Bookmarks";

	var instance : UIStoryboard {
		return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
	}

	func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
		let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
		return instance.instantiateViewController(withIdentifier: storyboardID) as! T
	}

	func initialViewController<T : UIViewController>() -> T{
		return instance.instantiateInitialViewController() as! T;
	}
}

extension UIViewController {

	class var storyboardID : String {
		return "\(self)ID"
	}

	static func instantiate(fromAppStoryboard appStoryboard : AppStoryboard) -> Self {
		return appStoryboard.viewController(viewControllerClass: self)
	}
	class var identifierID:String {
		return "\(self)Segue"
	}
}
