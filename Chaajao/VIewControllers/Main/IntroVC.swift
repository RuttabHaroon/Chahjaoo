//
//  IntroVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 05/10/2021.
//

import Foundation
import AdvancedPageControl
import UIKit

class IntroVC : BaseCustomController {

	@IBOutlet var pageControl: AdvancedPageControlView!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var skipBtn: BaseUIButton!
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var currentIndex = 0
	var introViewModel = IntroViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
		pageControl.setPageOffset(0)
		introViewModel.itemsUpdated = {
			self.setupTabs()
		}
		//introViewModel.getItems()
        //introViewModel.fetchItemsFromAPI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		sendNotification(notificationName: "introOrientationUpdate", data: nil)
	}

	func setupTabs() {
		for i in 0..<introViewModel.count {
			let vc = IntroSubVC.instantiate(fromAppStoryboard: .main)
			vc.introModel = introViewModel.items[i]
			controllerlist.append(vc)
		}
        
        
        generatePageControlUI()
		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		pagingViewController.backgroundColor = .clear
		pagingViewController.indicatorOptions = .hidden
		pagingViewController.borderOptions = .hidden
		pagingViewController.menuBackgroundColor = .clear
		pagingViewController.backgroundColor = .clear
		pagingViewController.menuItemSize = .fixed(width: pagingViewController.menuItemSize.width, height: 0)
		pagingViewController.delegate = self

		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = true

		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
	}


    
	override func backButtonTapped() {
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		super.backButtonTapped()
	}
}

extension IntroVC {
	@IBAction func skip() {
		backButtonTapped()
	}
	func goToTab(number: Int) {
		self.pagingViewController.select(index: number, animated: true)
	}
    
    func generatePageControlUI() {
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: introViewModel.count, height: 10, width: 10, space: 10, raduis: 5, currentItem: 0, indicatorColor: UIColor(named: "midRed"), dotsColor: UIColor(named: "focusOutColor"), isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
        pageControl.setPageOffset(0)
    }
}
//
//extension IntroVC : UIScrollViewDelegate {
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		pagingViewController.pageViewController.callScrollViewDelegate()
//		let width = WINDOW_WIDTH
//		var offSet = scrollView.contentOffset.x
//		if offSet >= width {
//			if currentIndex != 0 {
//				offSet = offSet * CGFloat(currentIndex + 1)
//			}
//			if abs(currentIndex - Int(floor(offSet / width))) <= 1 {
//				let newOffset = (offSet / width) - 1
//				if newOffset < CGFloat(introViewModel.count - 1) {
//
//				}
//
//			}
//		} else {
////			width = width * CGFloat((currentIndex + 1))
//
////			if abs(currentIndex - Int(ceil(offSet / width))) <= 1 {
////				pageControl.setPageOffset((offSet / width))
////			}
//		}
//	}
//}

//MARK: SelfSizingControllerDelegate
extension IntroVC : PagingViewControllerDelegate {
	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			currentIndex = (pagingItem as? PagingIndexItem)?.index ?? 0
			pageControl.setPageOffset(CGFloat(currentIndex))
			let newTitle = currentIndex == (introViewModel.count - 1) ? "DONE" : "SKIP"
			skipBtn.setTitle(newTitle, for: .normal)
		}
	}
}
