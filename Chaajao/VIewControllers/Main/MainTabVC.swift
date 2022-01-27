//
//  MainTabVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 20/08/2021.
//

import UIKit

class MainTabVC: BaseCustomController {

	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var starTrailingConstraint: NSLayoutConstraint!
	@IBOutlet var boy: UIImageView!
	@IBOutlet var star: UIImageView!
	@IBOutlet var icons: [BaseUIImageView]!
	@IBOutlet var splashView: UIStackView!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var tabBar: BaseUIView!
	@IBOutlet var askYourDoubtLabel: BaseUILabel!
	@IBOutlet var askYourDoubtBtn: BaseUIButton!
	@IBOutlet var mainView: UIView!
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var pendingNavigation = -1
	var currentPage = "home"
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupTabs()
//		NotificationCenter.default.addObserver(self, selector: #selector(setCornerView), name: NSNotification.Name("setCornerView"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(navigateToHome), name: NSNotification.Name("navigateToHome"), object: nil)
	}

	@objc func navigateToHome() {
		pendingNavigation = 0
	}

//	@objc func setCornerView() {
//		if UIApplication.shared.statusBarOrientation == .portrait {
//			cornerViewTopMarginConstraint.constant = EXERT_GLOBAL.statusBarHeight * -1
//			cornerViewTrailingMarginConstraint.constant = 0
//		} else {
//			cornerViewTopMarginConstraint.constant = 0
//			cornerViewTrailingMarginConstraint.constant = EXERT_GLOBAL.statusBarHeight * -1
//		}
//		EXERT_GLOBAL.tabBarHeight = tabBar.frame.height
//	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		updateIcons()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if !splashView.isHidden {
			hideSplashView()
		}
		if pendingNavigation != -1 && currentPage != "home" {
			currentPage = "home"
			goToTab(number: pendingNavigation)
			pendingNavigation = -1
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		setCornerView()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.setNavigationBarHidden(true, animated: false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		APP_DELEGATE.navController.setNavigationBarHidden(false, animated: false)
	}

	func setupTabs() {
		let vc1 = HomeVC.instantiate(fromAppStoryboard: .main)
        vc1.newsAdsViewModel = NewsAdsViewModel()
		let vc2 = AnalyticsTabVC.instantiate(fromAppStoryboard: .analytics)
		let vc3 = MenuVC.instantiate(fromAppStoryboard: .main)

		controllerlist.append(vc1)
		controllerlist.append(vc2)
		controllerlist.append(vc3)

		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		pagingViewController.indicatorOptions = .hidden
		pagingViewController.borderOptions = .hidden
		pagingViewController.menuBackgroundColor = EXERT_GLOBAL.controllerBackgroundColor

		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		pagingViewController.menuItemSize = .fixed(width: 0, height: 0)
		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = false
		pagingViewController.delegate = self
		self.addChild(pagingViewController)

		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
		EXERT_GLOBAL.tabBarHeight = tabBar.frame.height
	}

	func hideSplashView() {
		let starImage = star.image?
			.withRenderingMode(.alwaysTemplate)
		UIView.transition(with: self.star,
						  duration: 1,
						  options: [.transitionCrossDissolve, .allowAnimatedContent],
						  animations: { self.star.image = starImage },
						  completion: {_ in
							self.hideStack()
						  })
	}

	func hideStack() {
		self.mainView.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		UIView.animate(withDuration: 0.25, animations: {
			self.splashView.alpha = 0
		}, completion: {_ in
			self.splashView.isHidden = true

			self.askYourDoubtBtn.alpha = 1
			self.askYourDoubtLabel.alpha = 1
			self.tabBar.alpha = 1
		})
	}

	func navToSignUp() {
		let signUpVc = SignupVC.instantiate(fromAppStoryboard: .userAccess)
		APP_DELEGATE.navController.pushViewController(signUpVc, animated: true)
	}
	func navToCourses() {
		let coursesVc = CoursesVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(coursesVc, animated: true)
	}
	func navToAskYourDoubt() {
		let askYourDoubtVc = AskYourDoubtVC.instantiate(fromAppStoryboard: .askYourDoubt)
		APP_DELEGATE.navController.pushViewController(askYourDoubtVc, animated: true)
	}
}

//MARK: UI Delegates
extension MainTabVC {
	@IBAction func askYourDoubtTapped() {
		//navToAskYourDoubt()
	}

	func goToTab(number: Int) {
		self.pagingViewController.select(index: number, animated: false)
		updateIcons()
	}

	@IBAction func tabItemTapped(sender: UITapGestureRecognizer) {
		if let identifier = sender.view?.accessibilityIdentifier, identifier != "" {
			currentPage = identifier
			switch identifier {
				case "home":
					goToTab(number: 0)
				case "analytics":
					goToTab(number: 1)
				case "courses":
					navToCourses()
				case "menu":
					goToTab(number: 2)
				default: break
			}
		}
	}
	func updateIcons() {
		delay(0.1, closure: {
			if self.icons != nil {
				for icon in self.icons {
					if self.currentPage != "courses" {
						if icon.accessibilityIdentifier == self.currentPage {
							icon.tintColor = EXERT_GLOBAL.activeTabTint
						} else {
							icon.tintColor = EXERT_GLOBAL.inactiveTabTint
						}
					}
				}
			}
		})
	}
}

//MARK: PagingViewControllerDelegate
extension MainTabVC: PagingViewControllerDelegate {

	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			//MARK: TODO: On tab changed logic
		} else {
			print("failed")
		}
	}
}
