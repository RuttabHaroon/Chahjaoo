//
//  TestListVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 22/09/2021.
//

import Foundation
import UIKit
class TestListVC : BaseCustomController {
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: BaseUITextField!
    @IBOutlet weak var searchTextFieldHeightConstraint: NSLayoutConstraint!
    
    var tests = [[String:Any]]()
	var chapters = [[String:Any]]()
	var collectionViewSize = CGSize()
	var testName = "Topical Test"
    
    var dataResult : TestTypeResult?

    var disposableTestSet : [[String:Any]] = []
    var testSetForCurrentlySelectedChapter : [[String:Any]] = []
    var currentlySelectedChapter : Int? {
        didSet {
            if let selectedChapter = currentlySelectedChapter {
                testSetForCurrentlySelectedChapter.removeAll()
                testSetForCurrentlySelectedChapter = self.tests.filter({($0["chapterID"] as? Int ?? 0) == selectedChapter})
                disposableTestSet = testSetForCurrentlySelectedChapter
                tableView.reloadData()
            }
        }
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		setupData()
		addCollectionView()
		addTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadData()
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		reloadData()
	}

	func setupData() {
        
        self.searchTextFieldHeightConstraint.constant = testName == "Class Test" ? 40 : 0
        self.searchTextField.delegate = self
        
		chapters.removeAll()
        tests.removeAll()
		if testName == "Topical Test" || testName == "Chapter Test" {
            for i in 0..<(dataResult?.chapters?.count ?? 0) {
                addChapter(title: "Ch\(i+1)", selected: i == 0, chapterID: dataResult?.chapters?[i].id ?? 0)
                let currentChapter = dataResult?.chapters?[i]
                var j = 0
                print("tests in current chapter => \(currentChapter?.tests?.count ?? 0)")
                currentChapter?.tests?.forEach({ t in
                    
                    var iconName = ""
                    var hideRedoTestOption = true
                    let isSample = t.isSample ?? false
                    let isPurchased = t.isPurchased ?? false
                    let isAlreadyTaken = t.isAlreadyTaken ?? false
                    let questions = t.totalQuestion ?? 0
                    let testID = t.id ?? 0

                    if isSample == true && isAlreadyTaken == false{
                        iconName = "Start.Test"
                    }
                    else if isSample == true && isAlreadyTaken == true {
                        iconName = "Performance.Report"
                        hideRedoTestOption = false
                    }
                    else if isPurchased == false {
                        iconName = "PadLock.Filled"
                    }
                    else if isPurchased == true && isAlreadyTaken == false {
                        iconName = "Start.Test"
                    }
                    else if isPurchased == true && isAlreadyTaken == true {
                        iconName = "Performance.Report"
                        hideRedoTestOption = true
                    }
                    
                    addTest(icon: iconName,
                            title: "\(testName) - \(j+1)",
                            subTitle: "\(questions) Questions",
                            redoTestHidden: hideRedoTestOption,
                            testID: testID,
                            chapterID: dataResult?.chapters?[i].id ?? 0)
                    tests[j]["topSeparator"] = j != 0
                    tests[j]["bottomSeparator"] = j != 20
                    j+=1
                })
                currentlySelectedChapter = dataResult?.chapters?[0].id ?? 0
            }
		}
	}

    func addChapter(title: String, selected: Bool,chapterID : Int) {
		var chapter = [String:Any]()
		chapter["cellType"] = cellType.chaptersCollectionCell
		chapter["title"] = title
		chapter["selected"] = selected
        chapter["chapterID"] = chapterID
		chapters.append(chapter)
	}

    func addTest(icon: String, title: String, subTitle: String, redoTestHidden: Bool, testID: Int, chapterID: Int) {
		var test = [String:Any]()
		test["cellType"] = cellType.testListCell
		test["title"] = title
		test["icon"] = icon
		test["subTitle"] = subTitle
		test["redoTestHidden"] = redoTestHidden
        test["testID"] = testID
        test["chapterID"] = chapterID
        print(test)
		tests.append(test)
	}

    
	func addCollectionView() {
        print("testName \(testName)")
		if testName != "Topical Test" && testName != "Chapter Test" {
			collectionViewHeight.constant = 0
			collectionView.isHidden = true
		} else {
			var height = ExertUtility.convertToRatio(CGFloat(60))
			height = height > 60 ? CGFloat(60) : height
			var width = ExertUtility.convertToRatio(CGFloat(100))
			width = width > 100 ? CGFloat(100) : width
			collectionViewSize = CGSize(width: width, height: height)
			collectionViewHeight.constant = height
			ExertUtility.addcollectionView(collectionView:collectionView, st:[ChapterCell.cellIdentifier])
			let layout = UICollectionViewFlowLayout()
			layout.minimumLineSpacing = 0
			layout.minimumInteritemSpacing = 0
			layout.scrollDirection = .horizontal
			collectionView.isScrollEnabled = true
			collectionView.bounces = false
			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false
			collectionView?.collectionViewLayout = layout
		}
	}

	func addTableView() {
		ExertUtility.addTableviewNibs(tableView: tableView, st:[TestCell.cellIdentifier])
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.bounces = false
		tableView.restore()
	}

	func reloadData() {
		delay(0.05, closure: {
			self.tableView.reloadData()
			self.collectionView.reloadData()
		})
	}

    func navToTestVc(selectedTest: String, _  testID: Int = 0) {
		let testVc = PracticeTestInstructionsVC.instantiate(fromAppStoryboard: .practiceZone)
		testVc.testName = selectedTest
        testVc.testID = testID
		APP_DELEGATE.navController.pushViewController(testVc, animated: true)
	}

	func navToResultsVc() {
		let resultsVc = PracticeZoneResultVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(resultsVc, animated: true)
	}
}

//MARK: UICollectionViewDelegate
extension TestListVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return chapters.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChapterCell.cellIdentifier, for: indexPath) as! ChapterCell
		cell.updateData(chapters[indexPath.row])
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		return collectionViewSize
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}

//MARK: UITableViewDelegate/DataSource
extension TestListVC : UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disposableTestSet.count //tests.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		setHeight(indexPath: indexPath)
	}

	func setHeight (indexPath: IndexPath) -> CGFloat {
        let dict = self.disposableTestSet[indexPath.row] //self.tests[indexPath.row]

		if dict["isHidden"] as? Bool ?? false {
			return 0
		}
		switch (dict["cellType"] as? cellType ?? cellType.testListCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
		let data = self.disposableTestSet[indexPath.row] //self.tests[indexPath.row]

		switch data["cellType"] as? cellType {
			case .testListCell:
                //let temp = tableView.dequeueReusableCell(withIdentifier: TestCell.cellIdentifier) as!  TestCell
//				temp.delegate = self
//				cell = temp
//				cell.updateData(data)
            let temp = tableView.dequeueReusableCell(withIdentifier: TestCell.cellIdentifier) as! TestCell
            temp.delegate = self
            cell = temp
            cell.updateData(data)
            break
			default:
				return BaseUITableViewCell()
		}
		return cell
	}
}

//MARK: TestCellDelegate
extension TestListVC : TestCellDelegate {
    func tapped(cell: TestCell, testID: Int) {
        navToTestVc(selectedTest: cell.title.text ?? "", testID)
    }
    
	func tapped(cell: TestCell) {
		navToTestVc(selectedTest: cell.title.text ?? "")
	}
	func redoTapped(cell: TestCell) {
		//MARK: TODO: Redo test logic to be implemented here
		navToTestVc(selectedTest: cell.title.text ?? "")
	}

	func reportTapped(cell: TestCell) {
		navToResultsVc()
	}
	func lockTapped(cell: TestCell) {
		let alert = UIAlertController(title: "Alert", message: "This test is currently unavailable.", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

//MARK: ChapterCellDelegate
extension TestListVC : ChapterCellDelegate {
	func tapped(view: ChapterCell) {
		for i in 0..<chapters.count {
			chapters[i]["selected"] = view.button.titleLabel?.text == chapters[i]["title"] as? String
            if chapters[i]["selected"] as? Bool == true {
                print(chapters[i]["chapterID"] as? Int ?? 0)
                print(i)
                currentlySelectedChapter = (chapters[i]["chapterID"] as? Int ?? 0)
            }
		}
		reloadData()
	}
}

extension TestListVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            self.disposableTestSet =  self.testSetForCurrentlySelectedChapter
        }
        else {
            var temp = self.testSetForCurrentlySelectedChapter.filter({($0["title"] as? String ?? "").contains(textField.text ?? "")})
            self.disposableTestSet = temp
        }
        self.tableView.reloadData()
    }
}
