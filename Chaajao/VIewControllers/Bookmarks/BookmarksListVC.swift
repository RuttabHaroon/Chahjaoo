//
//  BookmarksListVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/10/2021.
//

import Foundation
class BookmarksListVC : BaseCustomController {

	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!

	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var searchBar: BaseUITextField!

	var bookmarksViewModel: BookmarksListViewModel?
	var filteredBookmarks: [QuestionModel]?

	var isSearchBarEmpty: Bool {
		return searchBar.text?.isEmpty ?? true
	}

	var isFiltering: Bool {
		return searchBar.isFirstResponder && !isSearchBarEmpty
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		addTableView(tableView: tableView, identifiers: [BookmarkCell.cellIdentifier])

		bookmarksViewModel = BookmarksListViewModel()
		bookmarksViewModel?.itemsUpdated = {
			self.tableView.reloadData()
		}
		bookmarksViewModel?.getData()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
	}

	func navToBookmarksDetail(question: QuestionModel) {
		let bookmarksDetailVc = BookmarkDetailVC.instantiate(fromAppStoryboard: .bookmarks)
		bookmarksDetailVc.questionModel = question
		APP_DELEGATE.navController.pushViewController(bookmarksDetailVc, animated: true)
	}

	func filterBookmarks(_ searchText: String) {
		if let questions = bookmarksViewModel?.items {
			filteredBookmarks = questions.filter { (question: QuestionModel) -> Bool in
				return question.text.lowercased().contains(searchText.lowercased()) || searchText.lowercased().contains("q.")
			}
			tableView.reloadData()
		}
	}
}

//MARK: Filter
extension BookmarksListVC  {
	@IBAction func searchTextChanged() {
		filterBookmarks(searchBar.text!)
	}
}

//MARK: IBActions
extension BookmarksListVC {
	@IBAction func back() {
		backButtonTapped()
	}
}

//MARK: TableViewDelegates
extension BookmarksListVC : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return isFiltering ? (filteredBookmarks?.count ?? 0) : (bookmarksViewModel?.count ?? 0)
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		navToBookmarksDetail(question: (bookmarksViewModel?.items[indexPath.row])!)
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return setHeight(indexPath: indexPath)
	}

	func setHeight (indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var data = [String:Any]()
		let model: QuestionModel = isFiltering ? filteredBookmarks![indexPath.row] : bookmarksViewModel!.items[indexPath.row]

		data["title"] = model.text
		data["category"] = model.category

		let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.cellIdentifier) as! BookmarkCell
		cell.updateData(data)
		return cell
	}
}
