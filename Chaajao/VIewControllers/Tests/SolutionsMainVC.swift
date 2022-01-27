//
//  SolutionsMainVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 08/10/2021.
//

import Foundation

class SolutionsMainVC : BaseCustomController {
	//MARK: IBOutlets
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var progress: GradientProgressView!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var mainCounter: UILabel!
	@IBOutlet var stepCounter: BaseUILabel!
	@IBOutlet var totalSteps: BaseUILabel!
	@IBOutlet var nextButtonLabel: UILabel!
	@IBOutlet var previousView: UIView!
	var currentIndex = 0
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var questionsViewModel: QuestionViewModel?
	var currentQuestion:CGFloat = 1

	override func viewDidLoad() {
		super.viewDidLoad()
		initializeQuiz()
	}

	override func backButtonTapped() {
		super.backButtonTapped()
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
	}

	func initializeQuiz() {

		questionsViewModel = QuestionViewModel()
		questionsViewModel?.itemsUpdated = {
			self.totalSteps.text = "/\(self.questionsViewModel?.count ?? 1)"
			self.setupTabs()
			self.updateProgressBar(animated: false)
			self.updateCurrentQuestion()
		}
		questionsViewModel?.getData(isSolution: true)
	}

	func setupTabs() {
		for i in 0..<(questionsViewModel?.count ?? 0) {
			let vc = QuizPageVC.instantiate(fromAppStoryboard: .tests)
			vc.questionNo = i + 1
			vc.question = questionsViewModel?.items[i]
			vc.isSolution = true
			controllerlist.append(vc)
		}

		pagingViewController = SelfSizingController(viewControllers: controllerlist)
		pagingViewController.delegate = self
		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		pagingViewController.indicatorOptions = .hidden
		pagingViewController.borderOptions = .hidden
		pagingViewController.menuBackgroundColor = EXERT_GLOBAL.controllerBackgroundColor

		pagingViewController.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor

		pagingViewController.menuItemSize = .fixed(width: pagingViewController.menuItemSize.width, height: 0)
		pagingViewController.pageViewController.scrollView.bounces = false
		pagingViewController.pageViewController.scrollView.isScrollEnabled = false
		self.addChild(pagingViewController)

		controllerView.addSubview(pagingViewController.view)
		controllerView.constrainToEdges(pagingViewController.view)
		pagingViewController.didMove(toParent: self)
	}

	func toggleTouchesOnCurrentQuestion(toggle: Bool) {
		if let vc = controllerlist[currentIndex] as? QuizPageVC {
			for subview in vc.view.subviews {
				if (subview as? ConfirmationActionSheetView) == nil {
					subview.isUserInteractionEnabled = toggle
				}
			}
		}
	}
}

//MARK: IBActions
extension SolutionsMainVC {
	@IBAction func close() {
		toggleTouchesOnCurrentQuestion(toggle: false)
		backButtonTapped()
	}

	@IBAction func nextQuestion() {
		if currentQuestion == 1 {
			previousView.alpha = 1
		}
		if currentQuestion < CGFloat(questionsViewModel?.count ?? 0) {
			currentQuestion += 1
			if currentQuestion == CGFloat(questionsViewModel?.count ?? 0) {
				nextButtonLabel.text = "CLOSE"
			}
			updateProgressBar()
			updateCurrentQuestion()
		} else if currentQuestion == CGFloat(questionsViewModel?.count ?? 0) {
			backButtonTapped()
		}
	}

	@IBAction func previousQuestion() {
		if currentQuestion != 1 {
			if currentQuestion == CGFloat(questionsViewModel?.count ?? 0) {
				nextButtonLabel.text = "NEXT"
			}
			currentQuestion -= 1
			if currentQuestion == 1 {
				previousView.alpha = 0
			}
			updateProgressBar()
			updateCurrentQuestion()
		}
	}
}

//MARK: Progress Updation Events
extension SolutionsMainVC {

	func updateCurrentQuestion() {
		stepCounter.text = "\(Int(currentQuestion))"
		updatePage()
	}

	func updatePage() {
		if pagingViewController != nil {

			UIView.animate(withDuration: 0.3, animations: {
				self.controllerView.alpha = 0
			}, completion: {_ in
				self.pagingViewController.select(index: Int(self.currentQuestion) - 1, animated: false)
				UIView.animate(withDuration: 0.3, animations: { self.controllerView.alpha = 1})
			})
		}
	}

	func updateProgressBar(animated: Bool = true) {
		let progressPc = floor(currentQuestion/CGFloat(questionsViewModel?.count ?? 0) * 100)/100
		progress.setProgress(Float(progressPc), animated: animated)
	}
}

extension SolutionsMainVC : ConfirmationActionSheetViewDelegate {
	func primaryButtonTapped(view: ConfirmationActionSheetView) {
		APP_DELEGATE.navController.popToRootViewController(animated: false)
		navToResultsVc()
		hideConfirmationView()
	}

	func secondaryButtonTapped(view: ConfirmationActionSheetView) {
		toggleTouchesOnCurrentQuestion(toggle: true)
		hideConfirmationView()
	}

	func navToResultsVc() {
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		let resultsVc = PracticeZoneResultVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(resultsVc, animated: true)
	}
}

//MARK: PagingViewControllerDelegate
extension SolutionsMainVC: PagingViewControllerDelegate {
	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			currentIndex = (pagingItem as? PagingIndexItem)?.index ?? 0
		}
	}
}
