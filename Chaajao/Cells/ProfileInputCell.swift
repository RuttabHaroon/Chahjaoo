//
//  ProfileInputCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 10/09/2021.
//

import UIKit

@objc protocol ProfileInputCellDelegate: AnyObject {
	@objc optional func inputFieldEdited(cell: ProfileInputCell)
	@objc optional func inputFieldEditingDidEnd(cell: ProfileInputCell)
}

class ProfileInputCell: BaseUITableViewCell {

	@IBOutlet weak var titleLabel: BaseUILabel!
	@IBOutlet weak var inputField: BaseUITextField!
	@IBOutlet weak var leadingButton: BaseUIButton!
	@IBOutlet weak var lineView: BaseUIView!
	
	var delegate: ProfileInputCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	override func updateData(_ data: Any?) {
		let dict = data as! [String:Any]

		titleLabel.text = dict["titleLabel"] as? String ?? ""
		inputField.text = dict["inputFieldText"] as? String ?? ""
		inputField.placeholder = dict["inputFieldPlaceholder"] as? String ?? ""
		if let iconName = dict["iconName"] as? String, iconName != "" {
			leadingButton.setImage(UIImage(named: iconName), for: .normal)
		}
		if dict["disabled"] as? Bool ?? false {
			inputField.isUserInteractionEnabled = false
		} else {
			inputField.isUserInteractionEnabled = true
		}
		toggleLine(toggle: false)
	}

	func toggleEdit(toggle: Bool) {
		if inputField.isUserInteractionEnabled {
			inputField.isUserInteractionEnabled = false
			inputField.resignFirstResponder()
		} else {
			inputField.isUserInteractionEnabled = true
			lineView.backgroundColor = UIColor(named: "midRed")
			inputField.becomeFirstResponder()
		}
	}
	func toggleLine(toggle: Bool) {
		lineView.backgroundColor = toggle ? UIColor(named: "midRed") : UIColor(named: "focusOutColor")
	}
}

//MARK: @IBActions
extension ProfileInputCell {
	@IBAction func inputFieldEdited() {
		delegate?.inputFieldEdited?(cell: self)
	}

	@IBAction func inputFieldDidEndEditing() {
		toggleLine(toggle: false)
		delegate?.inputFieldEditingDidEnd?(cell: self)
	}

	@IBAction func inputFieldDidBeginEditing() {
		toggleLine(toggle: true)
	}
}
