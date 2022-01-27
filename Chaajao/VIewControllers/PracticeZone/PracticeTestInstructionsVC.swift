//
//  PracticeTestInstructionsVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 23/09/2021.
//

import Foundation

class PracticeTestInstructionsVC : BaseCustomController {
    
    var testName = ""
    
    var testID = 0
    var vm = PracticeTestInstructionsViewModel()
    
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var instructions: UILabel!
    @IBOutlet weak var subjectLabel: BaseUILabel!
    @IBOutlet weak var numberOfQuestionsLabel: BaseUILabel!
    @IBOutlet weak var quizTimeLabel: BaseUILabel!
    
    
    override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = testName
        self.vm.getData(testID: testID)
        self.vm.onDataFetched = { [weak self] in
            if let t = self?.vm.testDetail {
                self?.numberOfQuestionsLabel.text = String(t.testSections?[0].totalQuestions ?? 0)
                self?.quizTimeLabel.text = String(t.testSections?[0].totalTime ?? 0)
                self?.instructions.text = t.testSections?[0].testSectionPoints?.joined(separator: ". ")
            }
        }
        
	}

	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func navToTestVC() {
		let testVc = TestMainVC.instantiate(fromAppStoryboard: .tests)
        testVc.testData = self.vm.testDetail
		APP_DELEGATE.navController.pushViewController(testVc, animated: true)
	}
}
