//
//  ChangePasswordVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 06/10/2021.
//

import Foundation

class ChangePasswordVC : BaseCustomController {

	@IBOutlet var tFields: [BaseUITextField]!
	@IBOutlet var uLines: [BaseUIView]!

    var vm : ChangePasswordViewModel = ChangePasswordViewModel()
    
    
	@IBAction func save() {
        self.vm.changeThePassword()
        self.vm.onPasswordUpdateSucess = { [weak self] in
            self?.backButtonTapped()
        }
	}
}
extension ChangePasswordVC : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let line = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "midRed")
		}
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let line = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "focusOutColor")
		}
        if textField.accessibilityIdentifier == "password" {
            self.vm.oldPassword = textField.text ?? ""
        }
        else if textField.accessibilityIdentifier == "newPassword" {
            self.vm.newPassword = textField.text ?? ""
        }
        else if textField.accessibilityIdentifier == "confirmPassword" {
            self.vm.confirmPassword = textField.text ?? ""
        }
		return true
	}
}
