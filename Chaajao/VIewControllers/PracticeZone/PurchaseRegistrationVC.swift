//
//  PurchaseRegistrationVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 21/09/2021.
//

import Foundation
class PurchaseRegistrationVC : BaseCustomController {

	@IBOutlet var genderLabel: UILabel!
	@IBOutlet var countryLabel: UILabel!
	@IBOutlet var cityLabel: UILabel!
	@IBOutlet var dobLabel: UILabel!
	@IBOutlet var uLines: [BaseUIView]!
	@IBOutlet var tFields: [BaseUITextField]!
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var scrollView: UIScrollView!

	var academicRecords = [AcademicRecordView]()
	var citiesList = [String]()
	var currentViewTag = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addDatePicker()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if academicRecords.count == 0 {
			addRecordTapped()
		}
	}

	
	@IBAction func addRecordTapped() {
		let newRecord = AcademicRecordView.loadNib() as! AcademicRecordView
		newRecord.tag = academicRecords.count
		newRecord.delegate = self
		var data = [String:Any]()
		data["removeHidden"] = academicRecords.count == 0
		newRecord.updateData(data: data)
		academicRecords.append(newRecord)
		delay(0, closure: {
			self.stackView.addArrangedSubview(newRecord)
			self.view.layoutIfNeeded()
			if self.academicRecords.count != 1 {
				self.scrollView.scrollToBottom(animated: true)
			}
		})
	}

	func openDatePicker(typeTag: Int) {
		dismissKeyboard()
		datePickerView?.delegate = self
		datePickerView?.datePick.datePickerMode = .date
		view.bringSubviewToFront(self.datePickerView!)
		datePickerView?.tag = typeTag
		datePickerView?.datePick.maximumDate = Date()
		datePickershow()
	}

	@IBAction func dropdownClicked(btn: UIButton) {
		dismissKeyboard()
		let identifier = btn.accessibilityIdentifier ?? ""
		if identifier == "Date Of Birth" {
			datePickerView?.titleValue.text = identifier
			openDatePicker(typeTag: 0)
		} else {
			multiPickerView?.titleLabel = identifier
			multiPickerView?.isMultSelection = false
			multiPickerView?.delegate = self
			var dropwDownDatalist = [DropDownData]()

			if identifier == "Gender" {
				multiPickerView?.tag = 0
				for i in 0..<genders.count {
					let title = genders[i]
					let id = i
					let tempData = DropDownData(ischecked: false, titeValue: title, Id: id)
					dropwDownDatalist.append(tempData)
				}
			} else if identifier == "Country" {
				multiPickerView?.tag = 1
				for i in 0..<countries.count {
					let title = countries[i]
					let id = i
					let tempData = DropDownData(ischecked: false, titeValue: title, Id: id)
					dropwDownDatalist.append(tempData)
				}
			} else if identifier == "City" {
				multiPickerView?.tag = 2
				citiesList = cities[countryLabel.text!]!
				for i in 0..<citiesList.count {
					let title = citiesList[i]
					let id = i
					let tempData = DropDownData(ischecked: false, titeValue: title, Id: id)
					dropwDownDatalist.append(tempData)
				}
			} else if identifier == "Degree" {
				multiPickerView?.tag = 3
				for i in 0..<degrees.count {
					let title = degrees[i]
					let id = i
					let tempData = DropDownData(ischecked: false, titeValue: title, Id: id)
					dropwDownDatalist.append(tempData)
				}
			}
			multiPickerView?.dropdown = dropwDownDatalist
			multiPickerView?.reloadData()
			dropdownshow()
			self.setNeedsFocusUpdate()
			self.updateFocusIfNeeded()
		}
	}
}

extension PurchaseRegistrationVC : AcademicRecordViewDelegate {
	func removeTapped(view: AcademicRecordView) {
		if view.tag != 0 {
			delay(0, closure: {
				self.academicRecords.remove(at: view.tag)
				self.stackView.removeArrangedSubview(view)
				view.removeFromSuperview()
				view.layoutIfNeeded()
			})
		}
	}
	func dropDownTapped(view: AcademicRecordView) {
		currentViewTag = view.tag
		dropdownClicked(btn: view.degreeBtn)
	}
}
extension PurchaseRegistrationVC : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let view = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			view.backgroundColor = UIColor(named: "midRed")
		}
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let view = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			view.backgroundColor = UIColor(named: "focusOutColor")
		}
		return true
	}
}

//MARK: MultiPickerViewDelegate
extension PurchaseRegistrationVC : MultiPickerViewDelegate {
	func pickerDoneClicked(tag: Int, dropDownData: DropDownData?, cell: UITableViewCell?) {
		dropdownhide()
		switch tag {
			case 0:
				genderLabel.text = dropDownData?.titleValue
			case 1:
				if countryLabel.text != dropDownData?.titleValue {
					cityLabel.text = ""
					countryLabel.text = dropDownData?.titleValue
				}
			case 2:
				cityLabel.text = dropDownData?.titleValue
			case 3:
				if let view = academicRecords.first(where: {$0.tag == currentViewTag}) {
					view.degreeLabel.text = dropDownData?.titleValue
				}
			default: break
		}
		self.view.becomeFirstResponder()
	}
}

//MARK: DatePickerViewDelegate
extension PurchaseRegistrationVC : DatePickerViewDelegate {
	func datePickerDoneClicked(tag: Int, date: Date, cell: UITableViewCell?) {
		let newDate = ExertUtility.dateToStringOld(date: date)
		if newDate != "" {
			dobLabel.text = newDate
		}
		self.datePickerhide()
	}
}
