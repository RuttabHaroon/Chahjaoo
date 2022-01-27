//
//  ProgramVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 14/09/2021.
//

import Foundation
class ProgramVC : BaseCustomController {
	@IBOutlet var tableView: BaseUITableView!
    
    var viewModel: ProgramsViewModel!
    
	@IBAction func goBack() {
		backButtonTapped()
	}

	@IBAction func done() {
        
        if let index = list.firstIndex(where: {($0["selected"] as? Bool ?? false) == true}) {
            let id = list[index]["ID"] as? Int ?? 0
            viewModel.programID = id
            viewModel.updateCourse()
            
        }
        else {
            Utility.showHudWithError(errorString: "Please select a program first")
        }
	}
	var list = [[String:Any]]()

	override func viewDidLoad() {
		super.viewDidLoad()
//        viewModel.getData()
//        viewModel.onUserSelectedProgramsFetched = { [weak self] intArr in
//            print(intArr)
////            intArr.forEach { i in
//                if let idx = self?.list.firstIndex(where: {$0["ID"] as? Int ?? 0 == i}) {
//                    self?.list[idx]["selected"] = true
//                }
//            }
//            if let idx =  self?.list.firstIndex(where: {($0["name"] as? String ?? "").lowercased() == UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programName?.lowercased() ?? ""}) {
//                self?.list[idx]["selected"] = true
//            }
//            self?.tableView.reloadData()
//        }
        
        
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        addTableView()
		setupData()
	}

	func addTableView() {
		ExertUtility.addTableviewNibs(tableView: tableView, st:[ProgramListCell.cellIdentifier])
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		tableView.backgroundView?.backgroundColor = EXERT_GLOBAL.controllerBackgroundColor
		tableView.restore()
	}

	func setupData() {
		self.list.removeAll()
        if let m = viewModel.courseList{
            m.programs?.forEach({ p in
                var shouldBeSelected = false
                if (p.name ?? "").lowercased() == (UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programName ?? "").lowercased() &&
                    p.id ?? 0 == UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programRelationID ?? 0 {
                    shouldBeSelected = true
                }
                print(p.name)
                print(p.id)
                print(shouldBeSelected)
                addProgram(ID: p.id ?? 0, title: p.name ?? "", selected: shouldBeSelected)
            })
        }
        print(list)
	}

    func addProgram(ID: Int ,title: String, selected: Bool) {
		var cell = [String:Any]()
		cell["title"] = title
		cell["selected"] = selected
		cell["cellType"] = cellType.programListCell
        cell["ID"] = ID
		list.append(cell)
	}
}

//MARK: TableViewDelegates
extension ProgramVC : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
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
		switch (dict["cellType"] as? cellType ?? cellType.programListCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
		let data = self.list[indexPath.row]

		switch data["cellType"] as? cellType {
			case .programListCell:
				let temp = tableView.dequeueReusableCell(withIdentifier: ProgramListCell.cellIdentifier) as! ProgramListCell;
				temp.delegate = self
				cell = temp
				cell.updateData(data)
			default:
				return BaseUITableViewCell()
		}
		return cell
	}
}

//MARK: ProgramListCellDelegate
extension ProgramVC : ProgramListCellDelegate {
	func tapped(cell: ProgramListCell) {
		for i in 0..<list.count {
			list[i]["selected"] = false
		}
		if let index = tableView.indexPath(for: cell) {
			list[index.row]["selected"] = true
		}
		tableView.reloadData()
	}
}

