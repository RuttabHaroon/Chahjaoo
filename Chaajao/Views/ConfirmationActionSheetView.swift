//
//  ConfirmationActionSheetView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 27/09/2021.
//

import Foundation
@objc protocol ConfirmationActionSheetViewDelegate: AnyObject {
	@objc func primaryButtonTapped(view: ConfirmationActionSheetView)
	@objc func secondaryButtonTapped(view: ConfirmationActionSheetView)
}

class ConfirmationActionSheetView : BaseUIView {

	@IBOutlet var headerLabel: BaseUILabel!
	@IBOutlet var descriptionLabel: BaseUILabel!
	@IBOutlet var primaryButton: BaseUIButton!
	@IBOutlet var secondaryButton: BaseUIButton!
	var _bottomConstraint : NSLayoutConstraint!
	var delegate: ConfirmationActionSheetViewDelegate?

	func setupView(header: String, desc: String, primaryActionTitle: String, secondaryActionTitle: String, _delegate: ConfirmationActionSheetViewDelegate) {
		headerLabel.text = header
		descriptionLabel.text = desc
		primaryButton.setTitle(primaryActionTitle, for: .normal)
		secondaryButton.setTitle(secondaryActionTitle, for: .normal)
		delegate = _delegate
	}
}

extension ConfirmationActionSheetView {
	@IBAction func primaryButtonTapped() {
		delegate?.primaryButtonTapped(view: self)

	}

	@IBAction func secondaryButtonTapped() {
		delegate?.secondaryButtonTapped(view: self)
	}

	func dismiss() {
		self.moveBottom(constantBottom: self.frame.height, animation: true, constraint: (self._bottomConstraint)!, delay: 0.5, completion: {
			self.isHidden = true
		})
	}
}
