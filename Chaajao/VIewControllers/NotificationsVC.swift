//
//  NotificationsVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 11/09/2021.
//

import UIKit

class NotificationsVC : BaseCustomController {

	@IBOutlet var tableView: BaseUITableView!
	var list = [[String:Any]]()

	override func viewDidLoad() {
		super.viewDidLoad()
		addTableView()
		setupData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()

	}

	@IBAction func back() {
		backButtonTapped()
	}

	func addTableView() {
		ExertUtility.addTableviewNibs(tableView: tableView, st:[NotificationCell.cellIdentifier])
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.restore()
	}

	func setupData() {
		self.list.removeAll()
		addCell(iconName: "Email", title: "Message", description: "Sir Adnan: If you have any other question, feel free to ask.", read: false)
		addCell(iconName: "Email", title: "Registration", description: "Your registration for live demo class is complete.", read: true)
		addCell(iconName: "Email", title: "Upcoming Class", description: "Class scheduled in 30 minutes.", read: false)
		addCell(iconName: "Email", title: "Recorded Class", description: "Recorded class available. Watch now!", read: false)
		addCell(iconName: "Email", title: "Your Performance", description: "Review your last test performance.", read: false)
		addCell(iconName: "Email", title: "Message", description: "Sir Adnan: No problem. Good luck.", read: false)
	}

	func addCell(iconName: String, title: String, description: String, read: Bool) {
		var dict = [String:Any]()
		dict["cellType"] = cellType.notificationCell
		dict["title"] = title
		dict["iconName"] = iconName
		dict["description"] = description
		dict["read"] = read
		list.append(dict)
	}
}

//MARK: TableViewDelegates
extension NotificationsVC : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		sendNotification(notificationName: "notificationTapped")
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return setHeight(indexPath: indexPath)
	}

	func setHeight (indexPath: IndexPath) -> CGFloat {
		let dict = self.list[indexPath.row]

		if dict["isHidden"] as? Bool ?? false {
			return 0
		}
		switch (dict["cellType"] as? cellType ?? cellType.notificationCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
		var data = self.list[indexPath.row]
		data["isFirst"] = indexPath.row == 0
		data["isLast"] = indexPath.row == self.list.count - 1
		switch data["cellType"] as? cellType {
			case .notificationCell:

				let tempCell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.cellIdentifier) as! NotificationCell
				tempCell.updateData(data)
				cell = tempCell
			default:
				return BaseUITableViewCell()
		}
		return cell
	}
}
