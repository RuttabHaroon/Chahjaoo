//
//  AcademicRecordView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 16/09/2021.
//

import UIKit
@objc protocol AcademicRecordViewDelegate: AnyObject {
	@objc func removeTapped(view: AcademicRecordView)
	@objc func dropDownTapped(view: AcademicRecordView)
}

class AcademicRecordView: BaseUIView {

	@IBOutlet var degreeLabel: UILabel!
	@IBOutlet var degreeBtn: UIButton!
	@IBOutlet var gradeTextField: BaseUITextField!
	@IBOutlet var gradeUnderline: BaseUIView!
	@IBOutlet var remove: UIButton!
	@IBOutlet var btnHeightConstraint: NSLayoutConstraint!
	var delegate: AcademicRecordViewDelegate?
	var removeHidden = false
	
	@IBAction func removeTapped() {
		delegate?.removeTapped(view: self)
	}
	@IBAction func dropDownTapped() {
		delegate?.dropDownTapped(view: self)
	}

	func updateData(data:Any) {
		if let data = data as? [String:Any] {
			removeHidden = data["removeHidden"] as? Bool ?? false
			gradeTextField.text = data["grade"] as? String ?? ""
			degreeLabel.text = data["degree"] as? String ?? "Matric"
			remove.isHidden = removeHidden
			btnHeightConstraint.constant = removeHidden ? 0 : 40
		}
	}
}

extension AcademicRecordView : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		gradeUnderline.backgroundColor = UIColor(named: "midRed")
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		gradeUnderline.backgroundColor = UIColor(named: "focusOutColor")
		return true
	}
}
