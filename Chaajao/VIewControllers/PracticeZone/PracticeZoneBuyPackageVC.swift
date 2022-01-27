//
//  PracticeZoneBuyPackageVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 16/09/2021.
//

import Foundation
class PracticeZoneBuyPackageVC: StepperController {
	@IBOutlet var stepperView: BaseUIView!
	@IBOutlet var heading: BaseUILabel!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var footerHeight: NSLayoutConstraint!
	@IBOutlet var footerTop: NSLayoutConstraint!
	@IBOutlet var footerBottom: NSLayoutConstraint!
	@IBOutlet var footerBtn: BaseUIButton!
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var nSteps = 3
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTabs()
	}

	func setupTabs() {
		let vc1 = PackagesVC.instantiate(fromAppStoryboard: .practiceZone)
		let vc2 = PurchaseRegistrationVC.instantiate(fromAppStoryboard: .practiceZone)
		let vc3 = PaymentMethodVC.instantiate(fromAppStoryboard: .practiceZone)

		controllerlist.append(vc1)
		controllerlist.append(vc2)
		controllerlist.append(vc3)

		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		pagingViewController.indicatorOptions = .hidden
		pagingViewController.borderOptions = .hidden
		pagingViewController.menuBackgroundColor = EXERT_GLOBAL.controllerBackgroundColor

		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor

		pagingViewController.menuItemSize = .fixed(width: pagingViewController.menuItemSize.width, height: 0)
		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = false
		pagingViewController.delegate = self
		self.addChild(pagingViewController)

		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
	}
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) || UIDevice.current.orientation == .portrait {
			DispatchQueue.main.async(execute: {
				self.stepperView.isHidden = true
				self.stepperView.removeAllSubviews()
				delay(0.3, closure: {
					self.restoreView(newSteps: self.addStepperView(parentView: self.stepperView, nSteps: self.nSteps))
					self.stepperView.isHidden = false
				})
			})
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) || UIDevice.current.orientation == .portrait {
			if self.steps == nil {
				DispatchQueue.main.async(execute: {
					self.steps = self.addStepperView(parentView: self.stepperView, nSteps: self.nSteps)
				})
				currentStep = 1
			} else {
				self.stepperView.isHidden = true
				self.stepperView.removeAllSubviews()
				DispatchQueue.main.async(execute: {
					self.restoreView(newSteps: self.addStepperView(parentView: self.stepperView, nSteps: self.nSteps))
					self.stepperView.isHidden = false
				})
			}
		}
	}

	func goToTab(number: Int) {
		self.pagingViewController.select(index: number, animated: false)
	}
}


//MARK: IBActions
extension PracticeZoneBuyPackageVC {

	@IBAction func back() {
		dismissKeyboard()
		if currentStep == 1 {
			backButtonTapped()
		} else {
			goToPreviousStep()
			if heading.text == "Registration" {
				heading.text = "Select Package"
				goToTab(number: 0)
			} else if heading.text == "Payment Method" {
				footerHeight.constant = 45
				footerTop.constant = 20
				footerBottom.constant = 20
				footerBtn.isHidden = false
				heading.text = "Registration"
				goToTab(number: 1)
			}
		}
	}

	@IBAction func close() {
		backButtonTapped()
	}

	@IBAction func next() {
		dismissKeyboard()
		if currentStep < nSteps {
			goToNextStep()
			if heading.text == "Select Package" {
				heading.text = "Registration"
				goToTab(number: 1)
			} else if heading.text == "Registration" {
				footerTop.constant = 0
				footerBottom.constant = 0
				footerHeight.constant = 0
				footerBtn.isHidden = true
				heading.text = "Payment Method"
				goToTab(number: 2)
			}
		}
	}
}

//MARK: PagingViewControllerDelegate
extension PracticeZoneBuyPackageVC: PagingViewControllerDelegate {

	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			//MARK: TODO: On tab changed logic
		} else {
			print("failed")
		}
	}
}
