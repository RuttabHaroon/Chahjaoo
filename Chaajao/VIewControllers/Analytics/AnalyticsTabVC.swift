//
//  AnalyticsTabVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 29/09/2021.
//

import Foundation

class AnalyticsTabVC : BaseCustomController {
	
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var currentIndex = 0
	@IBOutlet var controllerView: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabs()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let vc = controllerlist[currentIndex] as? PerformanceAnalyticsVC {
			delay(0.1, closure: {
				vc.reloadViews()
			})
		}
	}

	@IBAction func openNotifications() {
		let vc = NotificationsVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}

	@IBAction func navToProfileVc() {
		let profileVc = ProfileVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(profileVc, animated: true)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
	{
		super.willTransition(to: newCollection, with: coordinator)

		self.pagingViewController.collectionView.reloadData()
	}

	func setupTabs() {
		let vc1 = PerformanceAnalyticsVC.instantiate(fromAppStoryboard: .analytics)
		vc1.title = "Performance"
		let vc2 = PerformanceAnalyticsVC.instantiate(fromAppStoryboard: .analytics)
		vc2.title = "Progress"
		
		controllerlist.append(vc1)
		controllerlist.append(vc2)

		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		pagingViewController.indicatorOptions = .visible(
			height: 3,
			zIndex: Int.max,
			spacing: UIEdgeInsets.zero,
			insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

		pagingViewController.indicatorColor = EXERT_GLOBAL.activeTabTint
		pagingViewController.textColor = .black
		pagingViewController.selectedTextColor = .black
		pagingViewController.menuHorizontalAlignment = .left
		pagingViewController.delegate = self
		pagingViewController.menuBackgroundColor = .clear
		pagingViewController.font = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: CGFloat(12))!
		pagingViewController.selectedFont = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: CGFloat(12))!
		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = true

		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
	}
}

//MARK: SelfSizingControllerDelegate

extension AnalyticsTabVC : PagingViewControllerDelegate {
	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			currentIndex = (pagingItem as? PagingIndexItem)?.index ?? 0
			if let vc = controllerlist[currentIndex] as? PerformanceAnalyticsVC {
				vc.reloadViews()
			}
		}
	}
}
