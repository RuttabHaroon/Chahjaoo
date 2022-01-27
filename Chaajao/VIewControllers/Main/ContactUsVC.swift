//
//  ContactUsVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 08/10/2021.
//

import Foundation
class ContactUsVC : BaseCustomController {

	@IBOutlet var uLines: [BaseUIView]!
	@IBOutlet var tFields: [BaseUITextField]!
    @IBOutlet weak var messageTextView: BaseUITextView!
    
    var viewModel: ContactUsViewModel! = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}


//MARK: IBActions
extension ContactUsVC {
	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func submit() {
        let name = tFields.first?.text
        let email = tFields[1].text
        if (name == nil) || (email == nil) {
            alert(message: "Fiels are empty")
            return
        }
        let model = ContactUsModel(name: name!, email: email!, messageImage: "string", phoneNumber: "string", message: messageTextView.text, deviceToken: "string", appVersion: "string")
        viewModel.model = model
        viewModel.submitData()
	}
}

//MARK: UITextFieldDelegate
extension ContactUsVC : UITextFieldDelegate {

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		setLineColor(identifier: textField.accessibilityIdentifier ?? "", enabled: true)
		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		setLineColor(identifier: textField.accessibilityIdentifier ?? "", enabled: false)
		return true
	}
}

//MARK: UITextViewDelegate
extension ContactUsVC : UITextViewDelegate {
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		setLineColor(identifier: textView.accessibilityIdentifier ?? "", enabled: true)
		return true
	}

	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		setLineColor(identifier: textView.accessibilityIdentifier ?? "", enabled: false)
		return true
	}
}

extension ContactUsVC {
	func setLineColor(identifier: String, enabled: Bool) {
		let colorName = enabled ? "midRed" : "focusOutColor"
		if let view = uLines.first(where: {$0.accessibilityIdentifier == identifier}) {
			view.backgroundColor = UIColor(named: colorName)
		}
	}
}
