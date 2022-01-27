//
//  QuizPageVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 24/09/2021.
//

import Foundation
import UIKit
import SVLatexView

class QuizPageVC : BaseCustomController {
	@IBOutlet var questionLabel: BaseUILabel!
	@IBOutlet var timeElapsedLabel: BaseUILabel!
	@IBOutlet var questionNumber: BaseUIButton!
	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answerTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var back: BaseUIButton!
    @IBOutlet weak var questionView: UIView!
    
    
    var elapsedTime = 0
	var timer: Timer!
	var question: QuestionModel?
	var questionNo = 1
	var isSolution = false
    var onTapped: ((Int,Int, Bool)->Void)?
    var onMultiSelectTapped: (([Int],Int, Bool)->Void)?
    var onAnswerTyped : ((String,Int, Bool)->Void)?
    var onBookmarkTapped: ((Bool)->Void)?
    var bookmarked: Bool = false
    var selectedAnswerIndices : [Int] = []
    

    var latexView: SVLatexView?
    
    

	var list = [[String:Any]]()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		questionLabel.text = question?.text
		questionLabel.sizeToFit()
		questionNumber.setTitle(String(questionNo), for: .normal)

        handleLatexView()
        
        if  (question?.img ?? "")  != "" {
            questionImageViewHeightConstraint.constant = 100
            if let questionImgUrl = URL(string: question?.img ?? "") {
                questionImageView.kf.setImage(with: questionImgUrl)
            }
        }
        else {
            questionImageViewHeightConstraint.constant = 0
        }
        
        if  question?.questionType == 2 {
            answerTextView.text = "Write your answer here..."
            answerTextView.textColor = UIColor.lightGray
            answerTextView.delegate = self
            answerTextViewHeightConstraint.constant = 155
            tableView.isHidden = true
        }
        else {
            answerTextViewHeightConstraint.constant = 0
            tableView.isHidden = false
        }
        
		addTableView(tableView: tableView, identifiers: [AnswerView.cellIdentifier])
		for i in 0..<(question?.answers.count ?? 0) {
			addAnswer(answer: question?.answers[i], id: i+1)
		}
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setTableViewHeight()
		if !isSolution {
			validateTimer()
		} else {
			timeElapsedLabel.isHidden = true
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if !isSolution {
			invalidateTimer()
		}
	}

	@objc func updateTimer() {
		if !isSolution && (timer != nil || timer.isValid) {
			elapsedTime += 1
			updateElapesdTimeLabel()
		}
	}

	func updateElapesdTimeLabel() {
		let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
		var minute = String(newTime.0)
		var second = String(newTime.1)
		if minute.count < 2 {
			minute = "0" + minute
		}
		if second.count < 2 {
			second = "0" + second
		}
		timeElapsedLabel.text = "\(minute):\(second)"
	}

	func setTableViewHeight() {
		self.tableView.reloadData()
		delay(0.1, closure: {
			self.tableViewHeightConstraint.constant = self.tableView.contentSizeHeight
		})
	}

	func validateTimer() {
		if !isSolution && (timer == nil || !timer.isValid) {
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
		}
	}

	func invalidateTimer() {
		if !isSolution && timer != nil {
			timer.invalidate()
			timer = nil
		}
	}

	func addAnswer(answer: AnswerModel?, id: Int) {
		guard answer != nil else {
			return
		}
		var dict = [String:Any]()
		dict["cellType"] = cellType.answerCell
		dict["model"] = answer
		dict["id"] = id
		list.append(dict)
	}
    
    func handleLatexView(){
        self.questionView.setNeedsLayout()
        self.latexView = SVLatexView(frame: questionView.frame, using: SVLatexView.Engine.KaTeX, contentWidth: questionView.frame.size.width)
        self.latexView!.translatesAutoresizingMaskIntoConstraints = false
        self.latexView!.customCSS = ".formula-wrap {line-height: 16px;}"
        self.latexView!.sizeToFit()
        self.latexView!.setNeedsLayout()
        
        latexView!.loadLatexString(latexString: question?.text ?? "")
        view.addSubview(latexView!)
        latexView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: latexView, attribute: .leading, relatedBy: .equal, toItem: back, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: latexView, attribute: .trailing, relatedBy: .equal, toItem: questionView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: latexView, attribute: .top, relatedBy: .equal, toItem: questionView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: latexView, attribute: .bottom, relatedBy: .equal, toItem: questionView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: latexView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: questionView, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }
    
    @IBAction func onBookmarkTapped(_ sender: Any) {
        bookmarked = !bookmarked
        let bookmarkImageName = bookmarked == false ? "Bookmark" : "Bookmark.Filled"
        bookmarkButton.setImage(UIImage(named: bookmarkImageName), for: .normal)
        
        question?.isBookmarked = bookmarked
        if let b = onBookmarkTapped {
            b(bookmarked)
        }
    }
    
}


extension QuizPageVC : AnswerViewDelegate {
	func itemTapped(view: AnswerView) {
		for i in 0..<(question?.answers.count ?? 0) {
            //question type 4 is for multiple selection mcq
            if question?.questionType == 4 || question?.questionType == 3{
                if question?.answers[i].imageLink != "" {
                    if view.model.imageLink == question?.answers[i].imageLink {
                        if selectedAnswerIndices.contains(i) {
                            selectedAnswerIndices.removeAll(where: {$0 == i})
                            question?.answers[i].isSelected = false
                        }
                        else {
                            selectedAnswerIndices.append(i)
                            question?.answers[i].isSelected = true
                        }
                    }
                    else {
                        if selectedAnswerIndices.contains(i) {
                            //do nothing in this case
                        }
                        else {
                            question?.answers[i].isSelected = false
                        }
                    }
                    question?.isBookmarked = bookmarked
                    list[i]["model"] = question?.answers[i]
                    if selectedAnswerIndices.count > 0 {
                        if let t = onMultiSelectTapped {
                            let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
                            let totalTime = (newTime.0*60) + newTime.1
                            print("t: \(timer.timeInterval) b: \(totalTime)")
                            t(selectedAnswerIndices, totalTime, bookmarked)
                        }
                    }
                }
                else {
                    if view.model.text == question?.answers[i].text {
                        if selectedAnswerIndices.contains(i) {
                            selectedAnswerIndices.removeAll(where: {$0 == i})
                            question?.answers[i].isSelected = false
                        }
                        else {
                            selectedAnswerIndices.append(i)
                            question?.answers[i].isSelected = true
                        }
                    }
                    else {
                        if selectedAnswerIndices.contains(i) {
                            //do nothing in this case
                        }
                        else {
                            question?.answers[i].isSelected = false
                        }
                    }
                    question?.isBookmarked = bookmarked
                    list[i]["model"] = question?.answers[i]
                    if selectedAnswerIndices.count > 0 {
                        if let t = onMultiSelectTapped {
                            let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
                            let totalTime = (newTime.0*60) + newTime.1
                            print("t: \(timer.timeInterval) b: \(totalTime)")
                            t(selectedAnswerIndices, totalTime, bookmarked)
                        }
                    }
                }
            }
            //question type 1 is for single selection mcq
            else if question?.questionType == 1 {
                if question?.answers[i].imageLink != "" {
                    let isSelected = view.model.imageLink == question?.answers[i].imageLink
                    question?.answers[i].isSelected = isSelected
                    question?.isBookmarked = bookmarked
                    list[i]["model"] = question?.answers[i]
                    if isSelected == true {
                        if let t = onTapped {
                            let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
                            let totalTime = (newTime.0*60) + newTime.1
                            print("t: \(timer.timeInterval) b: \(totalTime)")
                            t(i, totalTime, bookmarked)
                        }
                    }
                }
                else {
                    let isSelected = view.model.text == question?.answers[i].text
                    question?.answers[i].isSelected = isSelected
                    question?.isBookmarked = bookmarked
                    list[i]["model"] = question?.answers[i]
                    if isSelected == true {
                        if let t = onTapped {
                            let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
                            let totalTime = (newTime.0*60) + newTime.1
                            print("t: \(timer.timeInterval) b: \(totalTime)")
                            t(i, totalTime, bookmarked)
                        }
                    }
                }
            }
		}
		tableView.reloadData()
	}
}

//MARK: UITableViewDelegate/DataSource
extension QuizPageVC : UITableViewDelegate, UITableViewDataSource {
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
		return list.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		setHeight(indexPath: indexPath)
	}

	func setHeight (indexPath: IndexPath) -> CGFloat {
		let dict = self.list[indexPath.row]

		if dict["isHidden"] as? Bool ?? false {
			return 0
		}
		switch (dict["cellType"] as? cellType ?? cellType.answerCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
		var data = self.list[indexPath.row]
		data["isViewingAsSolution"] = isSolution
		switch data["cellType"] as? cellType {
			case .answerCell:
				let temp = tableView.dequeueReusableCell(withIdentifier: AnswerView.cellIdentifier) as! AnswerView;
				temp.delegate = self
				cell = temp
				cell.updateData(data)
			default:
				return BaseUITableViewCell()
		}
		return cell
	}
}

extension QuizPageVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
             textView.text = "Write your answer here..."
             textView.textColor = UIColor.lightGray
         }
        if textView.text.isEmpty == false {
            if let answerTyped = onAnswerTyped {
                question?.isBookmarked = bookmarked
                let newTime = ExertUtility.getTimeInMS(seconds: elapsedTime)
                let totalTime = (newTime.0*60) + newTime.1
                print("t: \(timer.timeInterval) b: \(totalTime)")
                answerTyped(textView.text ?? "", totalTime, bookmarked)
            }
        }
    }
    
}
