//
//  OtpVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/09/2021.
//

import Foundation

class OtpVC : BaseCustomController {

	@IBOutlet weak var loader: BaseUIActivityIndicatorView!
	@IBOutlet weak var errorIcon: BaseUIImageView!
	@IBOutlet weak var statusLabel: BaseUILabel!
	@IBOutlet var otpFields: [BaseUITextField]!
	@IBOutlet var otpFieldsLines: [BaseUIView]!
	let otpCharacterSet = "1234567890"
	var otpArray = [Int:Int]()
    
    var vm : OTPViewModel = OTPViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
        self.vm.vc = self
	}

	deinit {
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.loader.startAnimating()
		self.resendCode()
	}
}

extension OtpVC {
	
	@IBAction func resendCode() {
		for field in otpFields {
			field.text = ""
		}
        
        vm.resentOTP()
        //vm.getPersonalProfile()
        //vm.updatePassword()
        //vm.abc()
	}

	@IBAction func goToSignUpLanding() {
		backButtonTapped()
	}
	func verify() {
        let sorted = Array(otpArray.keys).sorted(by: <)
        sorted.forEach { idx in
            self.vm.otpCode += String(otpArray[idx] ?? 0)
        }
        
        self.vm.otpCode = otpFields.map({$0.text ?? ""}).joined()
        self.vm.verifyOTP()
//		UserPreferences.isLoggedIn = true
//		self.toggleStatusView(loading: true)
//		delay(2, closure: {
//			self.toggleStatusView(loading: false, otpState: .verified)
//			self.goToEditMyProfile()
//		})
	}

	func goToEditMyProfile() {
		APP_DELEGATE.navController.setViewControllers([MainTabVC.instantiate(fromAppStoryboard: .main)], animated: false)
		let editVc = EditProfileVC.instantiate(fromAppStoryboard: .userAccess)
		APP_DELEGATE.navController.pushViewController(editVc, animated: true)
	}

	func toggleStatusView(loading: Bool, otpState: otpStates = otpStates.loading) {
		if loading {
			UIView.animate(withDuration: 0.3, animations: {
				self.errorIcon.alpha = 0
				self.loader.alpha = 1
			}, completion: {_ in
				self.loader.isHidden = false
				self.errorIcon.isHidden = true
				self.statusLabel.text = "Loading"
			})
		} else {
			UIView.animate(withDuration: 0.3, animations: {
				self.errorIcon.alpha = 1
				self.loader.alpha = 0
			}, completion: {_ in
				self.loader.isHidden = true
				self.errorIcon.isHidden = false
				switch otpState {
					case .sent:
						//self.errorIcon.image = .checkmark
						self.statusLabel.text = "Sent"
					case .verified:
						//self.errorIcon.image = .checkmark
						self.statusLabel.text = "Verified"
					case .error:
						self.errorIcon.image = UIImage(named: "exclamationmark.circle")
						self.statusLabel.text = "Error"
					default:break
				}
			})
		}
	}
}

extension OtpVC : UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let line = otpFieldsLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "midRed")
		}
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if let line = otpFieldsLines.first(where: {$0.accessibilityIdentifier == textField.accessibilityIdentifier}) {
			line.backgroundColor = UIColor(named: "focusOutColor")
		}
		return true
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if otpCharacterSet.contains(string) || string == "" {
			var found = false
			if string != "" {
				for field in otpFields {
					if found {
						field.becomeFirstResponder()
						break
					}
					if otpFields.last == field && !found {
                        textField.text = string
                        if let newDigit = Int(string) {
                            otpArray[Int(textField.accessibilityIdentifier ?? "1")!] = Int(newDigit)
                        }
						verify()
					}
					if field.accessibilityIdentifier == textField.accessibilityIdentifier {
						found = true
						if textField.text == "" {
							textField.text = string
							if let newDigit = Int(string) {
								otpArray[Int(textField.accessibilityIdentifier ?? "1")!] = Int(newDigit)
							}
						} else {
							for field in otpFields {
								if Int(field.accessibilityIdentifier ?? "1")! == Int(textField.accessibilityIdentifier ?? "1")! + 1 {
									if field.accessibilityIdentifier != "4" {
										field.becomeFirstResponder()
									} else {
										delay(0.05, closure: {
											field.resignFirstResponder()
											self.verify()
										})
									}
									field.text = string
									if let newDigit = Int(string) {
										otpArray[Int(textField.accessibilityIdentifier ?? "1")! + 1] = Int(newDigit)
									}
								}
							}
						}
						textField.resignFirstResponder()
					}
				}
			} else {
				for field in otpFields {
					if Int(field.accessibilityIdentifier ?? "1")! == Int(textField.accessibilityIdentifier ?? "1")! - 1 {
						delay(0.05, closure: {
							field.becomeFirstResponder()
						})
					}
				}
			}
			return true
		} else {
			return false
		}
	}
}
