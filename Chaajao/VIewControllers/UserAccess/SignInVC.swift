//
//  SignInVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 02/09/2021.
//

import UIKit
import ObjectMapper

class SignInVC : BaseCustomController {

    var signinVM = signinViewModel()
    
	@IBOutlet var lineViews: [BaseUIView]!
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        if !UserPreferences.shared().hasLaunchedBefore {
            UserPreferences.shared().hasLaunchedBefore = true
			navToIntroVc()
		}
	}
}

extension SignInVC {

	func navToIntroVc() {
		let introVc = IntroVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(introVc, animated: true)
	}

	@IBAction func navToSignUp() {
		let signUpVc = SignupVC.instantiate(fromAppStoryboard: .userAccess)
		APP_DELEGATE.navController.pushViewController(signUpVc, animated: true)
	}

	@IBAction func login() {
        signinVM.login()
	}

	@IBAction func navToForgotPassword() {
		let forgotPasswordVc = ForgotPasswordVC.instantiate(fromAppStoryboard: .userAccess)
		APP_DELEGATE.navController.pushViewController(forgotPasswordVc, animated: true)
	}
}

extension SignInVC : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let line = lineViews.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "midRed")
		}
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let line = lineViews.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "focusOutColor")
		}
        if textField.accessibilityIdentifier == "email" {
            self.signinVM.email = textField.text ?? ""
        }
        else if textField.accessibilityIdentifier == "password" {
            self.signinVM.password = textField.text ?? ""
        }
		return true
	}
}
