//
//  PracticeTestsVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 21/09/2021.
//

import Foundation
import UIKit
class PracticeTestsVC : BaseCustomController {
    
    var practiceTestVM: PracticeTestsViewModel = PracticeTestsViewModel()
    
    
	@IBOutlet var programLabel: BaseUILabel!
    @IBOutlet weak var classTestView: BaseUIView!
    
    
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        if let isOnCampus = UserPreferences.shared().userModelData?.isOnCampus {
            classTestView.isHidden = !isOnCampus
        }
        
	}
   

    
	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func chooseProgram() {
		dismissKeyboard()
		multiPickerView?.titleLabel = "Choose Program"
		multiPickerView?.isMultSelection = false
		multiPickerView?.delegate = self
//		var dropwDownDatalist = [DropDownData]()
		multiPickerView?.tag = 0

//		for i in 0..<purchasedCourses.count {
//			let title = purchasedCourses[i]
//			let id = i
//			let tempData = DropDownData(ischecked: false, titeValue: title, Id: id)
//			dropwDownDatalist.append(tempData)
//		}
        multiPickerView?.dropdown = self.practiceTestVM.dropwDownDatalist
		multiPickerView?.reloadData()
        
        if self.practiceTestVM.dropwDownDatalist.count <= 0 {
            Utility.showHudWithError(errorString: "No programs found!")
            return
        }
        
		dropdownshow()
		self.setNeedsFocusUpdate()
		self.updateFocusIfNeeded()
	}

	@IBAction func navToTestsListVC(sender: AnyObject) {
		let practicetestsListVc = PracticeTestPaginationVC.instantiate(fromAppStoryboard: .practiceZone)
		let testName = (sender as! UIButton).accessibilityIdentifier ?? "Topical Test"
		practicetestsListVc.testName = testName
        print("TEST NAMEW \(testName)")
        if testName == "Class Test" {
            UserPreferences.shared().userPickedTestType = TestType.classTest.rawValue
        }
        else if testName == "Mock Test" {
            UserPreferences.shared().userPickedTestType = TestType.subjectMockTest.rawValue
        }
        else if testName == "Grand Test" {
            UserPreferences.shared().userPickedTestType = TestType.grandTest.rawValue
        }
        else if testName == "Chapter Test" {
            UserPreferences.shared().userPickedTestType = TestType.chapterTest.rawValue
        }
        else {
            UserPreferences.shared().userPickedTestType = TestType.topicTest.rawValue
        }
		APP_DELEGATE.navController.pushViewController(practicetestsListVc, animated: true)
	}
}



extension PracticeTestsVC : MultiPickerViewDelegate {
	func pickerDoneClicked(tag: Int, dropDownData: DropDownData?, cell: UITableViewCell?) {
		dropdownhide()
		programLabel.text = dropDownData?.titleValue
        self.practiceTestVM.updateCourse(userSelectedProgramID: dropDownData?.Id ?? 0)
	}
}
