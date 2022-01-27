//
//  PracticeTestPaginationVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 22/09/2021.
//

import Foundation
class PracticeTestPaginationVC : BaseCustomController {
    
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var subjectsLabel: BaseUILabel!
    @IBOutlet weak var testDescriptionLabel: BaseUILabel!
    @IBOutlet var notificationsBtn: BaseUIButton!
    
    
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var testName = "Topical Test"
    var vm:PracticeTestPaginationViewModel?
    
    
    override func viewDidLoad() {
		super.viewDidLoad()
        self.testDescriptionLabel.text = "0 \(testName)"
        vm = PracticeTestPaginationViewModel()
        self.vm!.onDataLoaded = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dropDownView()
            weakSelf.setupTabs()

            var testCount = 0
            var subjectCount = 0
            weakSelf.vm?.dataArray.forEach({ i in
                subjectCount += 1
                i.chapters?.forEach({ j in
                    testCount += j.tests?.count ?? 0
                })
            })
            
            if weakSelf.testName == "Mock Test" || weakSelf.testName == "Grand Test" || weakSelf.testName == "Class Test" {
                weakSelf.testDescriptionLabel.text = "\(testCount) \(weakSelf.testName)s"
            }
            else {
                weakSelf.testDescriptionLabel.text = "\(testCount) \(weakSelf.testName)s | \(subjectCount) Subjects"
            }
            
        }
        
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
	{
		super.willTransition(to: newCollection, with: coordinator)

		self.pagingViewController.collectionView.reloadData()
	}

	func setupTabs() {
        print("testName \(testName)")
		if testName == "Topical Test" || testName == "Mock Test" || testName == "Chapter Test" {
            print(self.vm!.dataArray.count)
            print(self.vm!.dataArray[0].name)
            
            for i in 0..<(self.vm?.dataArray.count ?? 0) {
                let vc = TestListVC.instantiate(fromAppStoryboard: .practiceZone)
                vc.testName = testName
                vc.title = self.vm!.dataArray[i].name
                vc.dataResult = self.vm!.dataArray[i]
                controllerlist.append(vc)
            }
            
//            self.vm!.dataArray.forEach { element in
//                let vc = TestListVC.instantiate(fromAppStoryboard: .practiceZone)
//                vc.testName = testName
//                vc.title = element.name
//                vc.dataArray = self.vm!.dataArray
//                controllerlist.append(vc)
//
//                print(testName)
//                print(element.name)
//                print(self.vm!.dataArray)
//            }
		} else {
			subjectsLabel.isHidden = true
			let vc1 = TestListVC.instantiate(fromAppStoryboard: .practiceZone)
			vc1.testName = testName
			controllerlist.append(vc1)
		}

		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		if controllerlist.count == 1 {
//			pagingViewController.indicatorOptions = .hidden
//			pagingViewController.borderOptions = .hidden
//			pagingViewController.menuItemSize = .fixed(width: 0, height: 0)
            pagingViewController.indicatorColor = EXERT_GLOBAL.activeTabTint
            pagingViewController.textColor = .black
            pagingViewController.selectedTextColor = .black
            pagingViewController.selectedFont = UIFont(name: EXERT_GLOBAL.fontName, size: CGFloat(12))!
		} else {
			pagingViewController.indicatorOptions = .visible(
				height: 3,
				zIndex: Int.max,
				spacing: UIEdgeInsets.zero,
				insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
			pagingViewController.indicatorColor = EXERT_GLOBAL.activeTabTint
			pagingViewController.textColor = .black
			pagingViewController.selectedTextColor = .black
			pagingViewController.menuHorizontalAlignment = .center
			pagingViewController.font = UIFont(name: EXERT_GLOBAL.fontName, size: CGFloat(12))!
			pagingViewController.selectedFont = UIFont(name: EXERT_GLOBAL.fontName, size: CGFloat(12))!
		}
		pagingViewController.menuBackgroundColor = .clear
		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = true
		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
	}

	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func openNotifications() {
		let vc = NotificationsVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}
}
