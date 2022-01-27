//
//  TestMainVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 23/09/2021.
//

import Foundation

class TestMainVC : BaseCustomController {
	//MARK: IBOutlets
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var progress: GradientProgressView!
	@IBOutlet var controllerView: UIView!
	@IBOutlet var mainCounter: BaseUILabel!
	@IBOutlet var stepCounter: BaseUILabel!
	@IBOutlet var totalSteps: BaseUILabel!
	@IBOutlet var nextButtonLabel: UILabel!
	@IBOutlet var previousView: UIView!
	var currentIndex = 0
	var pagingViewController: SelfSizingController!
	var controllerlist = [UIViewController]()
	var questionsViewModel: QuestionViewModel?
	var currentQuestion:CGFloat = 1
	var timeLeft = HOUR/2
	var timer: Timer!
    
    var testData : TestDetail?
    var vm = TestMainViewModel()
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
		initializeQuiz()
	}

	override func backButtonTapped() {
		super.backButtonTapped()
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
	}

	func initializeQuiz() {

        if let t = testData?.testSections?[0] {
            timeLeft = t.totalTime ?? 0
        }
        
		questionsViewModel = QuestionViewModel()
		questionsViewModel?.itemsUpdated = {
			self.totalSteps.text = "/\(self.questionsViewModel?.count ?? 1)"
			self.setupTabs()
			self.updateProgressBar(animated: false)
			self.updateCurrentQuestion()
			self.updateMainCountDown()
		}
		//questionsViewModel?.getData()
        if let t = self.testData {
            questionsViewModel?.getData(testDetail: t)
        }
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		validateTimer()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		invalidateTimer()
	}

	func setupTabs() {
		for i in 0..<(questionsViewModel?.count ?? 0) {
			let vc = QuizPageVC.instantiate(fromAppStoryboard: .tests)
			vc.questionNo = i + 1
			vc.question = questionsViewModel?.items[i]
			controllerlist.append(vc)
            
            //for single selection aka Question Type 1
            vc.onTapped = { [weak self] (index, time, isBookmarked) in
                //resettinging values
                for answerIndex in 0..<(self?.questionsViewModel?.items[i].answers.count ?? 0) {
                    self?.questionsViewModel?.items[i].answers[answerIndex].isSelected = false
                }
                
                self?.questionsViewModel?.items[i].answers[index].isSelected = true
                self?.questionsViewModel?.items[i].timeTaken = time
                self?.questionsViewModel?.items[i].isBookmarked = isBookmarked
                print("question \(vc.question?.questionID) has selected answer with index \(vc.question?.answers[index].answerID) and text \(vc.question?.answers[index].text) and time \(vc.question?.timeTaken)")
            }
            
            //for multiple selection aka Question Type 4 and 3
            vc.onMultiSelectTapped = { [weak self] (indices, time, isBookmarked) in
                //resettinging values
                for answerIndex in 0..<(self?.questionsViewModel?.items[i].answers.count ?? 0) {
                    self?.questionsViewModel?.items[i].answers[answerIndex].isSelected = false
                }
                
                indices.forEach { answerIndex in
                    self?.questionsViewModel?.items[i].answers[answerIndex].isSelected = true
                    self?.questionsViewModel?.items[i].timeTaken = time
                    self?.questionsViewModel?.items[i].isBookmarked = isBookmarked
                    print("question \(vc.question?.questionID) has selected answer with index \(vc.question?.answers[answerIndex].answerID) and text \(vc.question?.answers[answerIndex].text) and time \(vc.question?.timeTaken)")
                }
            }
            
            vc.onAnswerTyped = { [weak self] (typedAnswer, time, isBookmarked) in
                self?.questionsViewModel?.items[i].questionAnswerTyped = typedAnswer
                self?.questionsViewModel?.items[i].timeTaken = time
                self?.questionsViewModel?.items[i].isBookmarked = isBookmarked
            }
            
            vc.onBookmarkTapped = { [weak self] (bookmarked)in
                self?.questionsViewModel?.items[i].isBookmarked = bookmarked
            }
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
	func toggleTimers(toggle: Bool) {
		if let vc = controllerlist[currentIndex] as? QuizPageVC {
			if toggle {
				vc.validateTimer()
			} else {
				vc.invalidateTimer()
			}
		}
		if toggle {
			validateTimer()
		} else {
			invalidateTimer()
		}
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
extension TestMainVC {
	@IBAction func close() {
		toggleTimers(toggle: false)
		toggleTouchesOnCurrentQuestion(toggle: false)
		setupConfirmationActionView()
		confirmationView?.setupView(header: "Submit Test?", desc: "Hey, Ahmed, are you sure you want to\nend this test?", primaryActionTitle: "SUBMIT", secondaryActionTitle: "Cancel", _delegate: self)
		self.showConfirmationView()
	}

	@IBAction func nextQuestion() {
		if currentQuestion == 1 {
			previousView.alpha = 1
		}
		if currentQuestion < CGFloat(questionsViewModel?.count ?? 0) {
			currentQuestion += 1
			if currentQuestion == CGFloat(questionsViewModel?.count ?? 0) {
				nextButtonLabel.text = "SUBMIT"
			}
			updateProgressBar()
			updateCurrentQuestion()
		} else if currentQuestion == CGFloat(questionsViewModel?.count ?? 0) {
			setupConfirmationActionView()
			confirmationView?.setupView(header: "Submit Test?", desc: "Hey, Ahmed, are you sure you want to\nend this test?", primaryActionTitle: "SUBMIT", secondaryActionTitle: "Cancel", _delegate: self)
			self.showConfirmationView()
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

	@IBAction func reportAnIssueTapped() {
		_ = ExertUtility.messagePopup(message: "Feedback recorded.\nYou may be contacted via email.")
	}
}

//MARK: Progress Updation Events
extension TestMainVC {

	@objc func updateMainTimer() {
		if timer != nil || timer.isValid {
			timeLeft -= 1
			updateMainCountDown()
		}
	}

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

	func updateMainCountDown() {
        if timeLeft <= 0 {
            Utility.showHudWithError(1.1, errorString: "Times Up!. Please try again later!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                // your code here
                self.navigationController?.popViewController(animated: true)
            }
        }
		let newTime = ExertUtility.getTimeInMS(seconds: timeLeft)
		var minute = String(newTime.0)
		var second = String(newTime.1)
		if minute.count < 2 {
			minute = "0" + minute
		}
		if second.count < 2 {
			second = "0" + second
		}
		mainCounter.text = "Time Left: \(minute):\(second)"
	}

	func updateProgressBar(animated: Bool = true) {
		let progressPc = floor(currentQuestion/CGFloat(questionsViewModel?.count ?? 0) * 100)/100
		progress.setProgress(Float(progressPc), animated: animated)
	}

	func validateTimer() {
		if timer == nil || !timer.isValid {
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
		}
	}

	func invalidateTimer() {
		if timer != nil {
			timer.invalidate()
			timer = nil
		}
	}
}

extension TestMainVC : ConfirmationActionSheetViewDelegate {
	func primaryButtonTapped(view: ConfirmationActionSheetView) {
        if let t = testData {
            self.vm.submitTest(testData: t, questionModel: self.questionsViewModel?.items ?? [])
            self.vm.onComplete = { [weak self] status in
                guard let weakSelf = self else {return}
                if status == true {
                    APP_DELEGATE.navController.popToRootViewController(animated: false)
                    weakSelf.navToTestsVc()
                    weakSelf.hideConfirmationView()
                }
                else {

                }
            }
        }
	}

	func secondaryButtonTapped(view: ConfirmationActionSheetView) {
		toggleTimers(toggle: true)
		toggleTouchesOnCurrentQuestion(toggle: true)
		hideConfirmationView()
	}

	func navToTestsVc() {
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		let testVc = TestResultVC.instantiate(fromAppStoryboard: .tests)
        testVc.quizResultData = self.vm.requestModel
        testVc.testDetailData = self.testData
		APP_DELEGATE.navController.pushViewController(testVc, animated: true)
	}
}

//MARK: PagingViewControllerDelegate
extension TestMainVC: PagingViewControllerDelegate {
	func pagingViewController(_ pagingViewController: PagingViewController, didScrollToItem pagingItem: PagingItem, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
		if transitionSuccessful {
			currentIndex = (pagingItem as? PagingIndexItem)?.index ?? 0
		}
	}
}
