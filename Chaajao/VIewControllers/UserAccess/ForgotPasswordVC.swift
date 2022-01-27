//
//  ForgotPasswordVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 28/09/2021.
//

import Foundation

class ForgotPasswordVC : BaseCustomController {

	@IBOutlet var tFields: [BaseUITextField]!
	@IBOutlet var uLines: [BaseUIView]!
	
    var vm = ForgotPasswordViewModel()
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	@IBAction func goToStepTwo() {
        self.vm.sendForgotPasswordRequest()
//		let otpVc  = OtpVC.instantiate(fromAppStoryboard: .userAccess)
//		APP_DELEGATE.navController.pushViewController(otpVc, animated: true)
	}
	
	@IBAction func navToSignIn() {
		backButtonTapped()
	}
}
extension ForgotPasswordVC : UITextFieldDelegate {

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
        self.vm.email = textField.text ?? ""
		return true
	}
    
}
