//
//  SignupVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 01/09/2021.
//

import UIKit

class SignupVC : BaseCustomController {

    var signupVM = SignupViewModel()
    
	@IBOutlet var tFields: [BaseUITextField]!
	@IBOutlet var uLines: [BaseUIView]!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

extension SignupVC : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let view = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			view.backgroundColor = UIColor(named: "midRed")
		}
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let view = uLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			view.backgroundColor = UIColor(named: "focusOutColor")
            if textField.accessibilityIdentifier == "name" {
                self.signupVM.name = textField.text ?? ""
            }
            else if textField.accessibilityIdentifier == "email" {
                self.signupVM.email = textField.text ?? ""
            }
            else if textField.accessibilityIdentifier == "whatsapp" {
                self.signupVM.whatsapp_number = textField.text ?? ""
            }
            else if textField.accessibilityIdentifier == "password" {
                self.signupVM.password = textField.text ?? ""
            }
            else if textField.accessibilityIdentifier == "confirmPassword" {
                self.signupVM.confirmPassword = textField.text ?? ""
            }
		}
		return true
	}
}

extension SignupVC {

	@IBAction func goToStepTwo() {
        signupVM.signupUser()
        
	}

	@IBAction func navToSignIn() {
		backButtonTapped()
	}
}
