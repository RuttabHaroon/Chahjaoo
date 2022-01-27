//
//  BookmarkDetailVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/10/2021.
//

import Foundation
import UIKit
class BookmarkDetailVC: BaseCustomController {

	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var tableViewHeightConstraint : NSLayoutConstraint!
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var question : UILabel!
	@IBOutlet var bookmarkButton: BaseUIButton!

	var questionModel: QuestionModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		question.text = questionModel?.text
		addTableView(tableView: tableView, identifiers: [AnswerView.cellIdentifier])
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setTableViewHeight()
	}

	func setTableViewHeight() {
		self.tableView.reloadData()
		delay(0.1, closure: {
			self.tableViewHeightConstraint.constant = self.tableView.contentSizeHeight
		})
	}
}

//MARK: BaseUITableViewDelegate

extension BookmarkDetailVC : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var data = [String:Any]()
		data["cellType"] = cellType.answerCell
		data["isViewingAsBookmark"] = true
		data["model"] = questionModel?.answers[indexPath.row]
		data["id"] = indexPath.row + 1

		let cell = tableView.dequeueReusableCell(withIdentifier: AnswerView.cellIdentifier) as! AnswerView;
		cell.updateData(data)
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return questionModel?.answers.count ?? 0
	}
}

//MARK: IBActions
extension BookmarkDetailVC {
	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func share() {
		let screenshot = scrollView.takeScreenshot()
		shareImage(image: screenshot)
	}

	@IBAction func bookmark() {
		bookmarkButton.setImage(UIImage(named: "Bookmark"), for: .normal)
		self.view.isUserInteractionEnabled = false
		delay(0.2, closure: {
			self.backButtonTapped()
		})
	}
}
