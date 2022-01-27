//
//  CoursesVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 14/09/2021.
//

import Foundation

class CoursesVC : BaseCustomController {
	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var bottomSpaceConstraint: NSLayoutConstraint!

    
    var vm: CourseViewModel = CourseViewModel()
    
	@IBAction func done() {
		navToProgramVc()
	}

	func navToProgramVc() {
		let programVc = ProgramVC.instantiate(fromAppStoryboard: .main)
        programVc.viewModel = ProgramsViewModel()
        self.vm.list.forEach { element in
            print(element["items"])
            if let modelArray = element["items"] as? [CoursePickerModel] {
                if let idx = modelArray.first(where: {$0.isSelected == true}) {
                    programVc.viewModel.courseList = idx
                }
            }
        }
        APP_DELEGATE.navController.pushViewController(programVc, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addTableView()
		//setupData()
		NotificationCenter.default.addObserver(self, selector: #selector(setCornerView), name: NSNotification.Name("setCornerView"), object: nil)
	}

	@objc func setCornerView() {
		DispatchQueue.main.async {
            for i in 0..<self.vm.list.count {
                self.vm.list[i]["forceRefresh"] = true
			}
			self.tableView.reloadData()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadData()
        
        vm.getStreamList()
        vm.onSucess = { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.tableView.reloadData()
        }
	}

	func addTableView() {
		ExertUtility.addTableviewNibs(tableView: tableView, st:[BankingListCell.cellIdentifier])
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.restore()
	}

	func reloadData() {
		delay(0.05, closure: {
			self.tableView.reloadData()
			self.bottomSpaceConstraint.constant = 15
		})
	}

//	func setupData() {
//
//		self.vm.list.removeAll()
//		addCategory(title: "ECAT", description: "Engineering College Admission Test", count: 2, isExpanded: false)
//
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "NUST", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "GIKI", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "PIEAS", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "FAST", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "IST", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "NED", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "COMSAT", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "UET", iconName: "nust", isSelected: false))
//        self.vm.ecatModels.append(CoursePickerModel.init(instituteName: "KU", iconName: "nust", isSelected: false))
//        self.vm.list[0]["items"] = self.vm.ecatModels
//
//		addCategory(title: "BCAT", description: "Business College Admission Test", count: 0, isExpanded: false)
//
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "IBA", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "LUMS", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "IoBM", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "SZABIST", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "LSE", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "IQRA", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "BAHRIA", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "USP", iconName: "nust", isSelected: false))
//        self.vm.bcatModels.append(CoursePickerModel.init(instituteName: "KU", iconName: "nust", isSelected: false))
//        self.vm.list[1]["items"] = self.vm.bcatModels
//
//		addCategory(title: "MCAT", description: "Medical College Admission Test", count: 0, isExpanded: false)
//
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "AKU", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "UHS", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "KEMU", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "DUHS", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "JSMU", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "KMDC", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "KMU", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "LUMHS", iconName: "nust", isSelected: false))
//        self.vm.mcatModels.append(CoursePickerModel.init(instituteName: "ZIAUDDIN", iconName: "nust", isSelected: false))
//        self.vm.list[2]["items"] = self.vm.mcatModels
//	}

//	func addCategory(title: String, description: String, count: Int, isExpanded: Bool) {
//		var cell = [String:Any]()
//		cell["isExpanded"] = isExpanded
//		cell["title"] = title
//		cell["description"] = description
//		cell["count"] = count
//		cell["cellType"] = cellType.courseListCell
//        self.vm.list.append(cell)
//	}
}

//MARK: TableViewDelegates
extension CoursesVC : UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let c = cell as? BankingListCell {
            c.updateData(self.vm.list[indexPath.row])
		}
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.list.count
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
        let dict = self.vm.list[indexPath.row]

		if dict["isHidden"] as? Bool ?? false {
			return 0
		}
		switch (dict["cellType"] as? cellType ?? cellType.courseListCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
        let data = self.vm.list[indexPath.row]

		switch data["cellType"] as? cellType {
			case .courseListCell:
				let temp = tableView.dequeueReusableCell(withIdentifier: BankingListCell.cellIdentifier) as! BankingListCell;
				temp.delegate = self
				cell = temp
				cell.updateData(data)
			default:
				return BaseUITableViewCell()
		}
		return cell
	}
}

//MARK: BankingListCellDelegate
extension CoursesVC : BankingListCellDelegate {

	func updateList(cell: BankingListCell, newList: [CoursePickerModel]) {
		if let index = tableView.indexPath(for: cell) {
            for i in 0..<self.vm.list.count {
				if i == index.row {
                    self.vm.list[index.row]["items"] = newList
				} else {
                    if self.vm.list[i]["title"] as? String == "ECAT" {
                        self.vm.list[i]["items"] = self.vm.ecatModels
                    } else if self.vm.list[i]["title"] as? String == "BCAT" {
                        self.vm.list[i]["items"] = self.vm.bcatModels
                    } else if self.vm.list[i]["title"] as? String == "MCAT" {
                        self.vm.list[i]["items"] = self.vm.mcatModels
					}
				}
			}
		}
	}

	func forceRefreshed(cell: BankingListCell) {
		if let index = tableView.indexPath(for: cell) {
            self.vm.list[index.row]["forceRefresh"] = false
		}
	}

	func toggleTapped(cell: BankingListCell, isExpanded: Bool) {
		if let index = tableView.indexPath(for: cell) {
            for i in 0..<self.vm.list.count {
                self.vm.list[i]["isExpanded"] = false
			}
			tableView.reloadData()
            self.vm.list[index.row]["isExpanded"] = isExpanded
			self.tableView.scrollToRow(at: index, at: .top, animated: true)
		}
	}
}
