//
//  PaymentMethodVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 21/09/2021.
//

import Foundation
import YPImagePicker
import UIKit

class PaymentMethodVC : BaseCustomController {
	var currentCashDetailsHeight: CGFloat = 0

	@IBOutlet var uLines: [BaseUIView]!
	@IBOutlet var tFields: [BaseUITextField]!
	@IBOutlet var courseName: BaseUILabel!
	@IBOutlet var courseCategory: BaseUILabel!
	@IBOutlet var courseTimeline: BaseUILabel!
	@IBOutlet var coursePrice: BaseUILabel!
	@IBOutlet var radioButtons: [BaseUIButton]!
	@IBOutlet var paymentMethods: [BaseUIView]!
	@IBOutlet var cardDetailChildViews: [UIView]!
	@IBOutlet var ePDetailChildViews: [UIView]!
	@IBOutlet var jCDetailChildViews: [UIView]!
	@IBOutlet var ibftDetailChildViews: [UIView]!
	@IBOutlet var transactionImage: UIImageView!
	var selected = ""

	override func viewDidLoad() {
		super.viewDidLoad()

		courseName.text = "NUST LIVE COURSE 2021"
		courseCategory.text = "Chaajao Advanced"
		courseTimeline.text = "Starts 1st July - Ends 30th August"
		coursePrice.text = "PKR 15,000"
	}

	@IBAction func navToPurchaseSuccessVc() {
		APP_DELEGATE.navController.popToRootViewController(animated: false)
		let purchaseSuccessVc = PurchaseSuccessVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(purchaseSuccessVc, animated: true)
	}
}
//MARK: IBActions
extension PaymentMethodVC {
	@IBAction func openImagePicker() {
		let picker = YPImagePicker()
		picker.didFinishPicking { [unowned picker] items, _ in
			if let photo = items.singlePhoto {
				self.transactionImage.image = photo.image
			}
			picker.dismiss(animated: true, completion: nil)
		}
		present(picker, animated: true, completion: nil)
	}

	@IBAction func paymentMethodSelected(btn: UIButton) {
		dismissKeyboard()
		let identifier: PaymentMethod = PaymentMethod(rawValue: btn.accessibilityIdentifier!)!
		selected = identifier.rawValue
		switch identifier {
			case .Card:
				DispatchQueue.main.async {
					self.toggleIBFTDetails(toggle: false)
					self.toggleJCDetails(toggle: false)
					self.toggleEPDetails(toggle: false)
					self.toggleCashDetails(toggle: true)
				}
			case .EasyPaisa:
				DispatchQueue.main.async {
					self.toggleIBFTDetails(toggle: false)
					self.toggleJCDetails(toggle: false)
					self.toggleCashDetails(toggle: false)
					self.toggleEPDetails(toggle: true)
				}
			case .JazzCash:
				DispatchQueue.main.async {
					self.toggleIBFTDetails(toggle: false)
					self.toggleEPDetails(toggle: false)
					self.toggleCashDetails(toggle: false)
					self.toggleJCDetails(toggle: true)
				}
			case .IBFT:
				DispatchQueue.main.async {
					self.toggleJCDetails(toggle: false)
					self.toggleEPDetails(toggle: false)
					self.toggleCashDetails(toggle: false)
					self.toggleIBFTDetails(toggle: true)
				}
		}
		for button in radioButtons {
			if button.accessibilityIdentifier == identifier.rawValue {
				button.setImage(UIImage(named: "Radio.Selected"), for: .normal)
			} else {
				button.setImage(UIImage(named: "Radio.Unselected"), for: .normal)
			}
		}
	}
}

extension PaymentMethodVC {
	func toggleIBFTDetails(toggle: Bool) {
		toggleChildren(children: ibftDetailChildViews, toggle: toggle)
	}

	func toggleCashDetails(toggle: Bool) {
		toggleChildren(children: cardDetailChildViews, toggle: toggle)
	}

	func toggleJCDetails(toggle: Bool) {
		toggleChildren(children: jCDetailChildViews, toggle: toggle)
	}

	func toggleEPDetails(toggle: Bool) {
		toggleChildren(children: ePDetailChildViews, toggle: toggle)
	}

	func toggleChildren(children: [UIView], toggle: Bool) {
		for child in children {
			child.isHidden = !toggle
		}
		animateChanges()
	}

	func animateChanges() {
		UIView.animate(withDuration: 0.3, animations: {
			self.view.layoutIfNeeded()
		})
	}
}

extension PaymentMethodVC : UITextFieldDelegate {

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
