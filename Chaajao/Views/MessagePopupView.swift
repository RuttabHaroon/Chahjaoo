//
//  MessagePopupView.swift
//  CDC
//
//  Created by Ahmed Khan on 31/08/2021.
//  Copyright © 2021 Ahmed Khan. All rights reserved.
//

import UIKit

@objc protocol MessagePopupViewDelegate: AnyObject {
    
    @objc optional func positiveBtnTapped(klcPopup: KLCPopup?, messagePopupView: MessagePopupView)
	@objc optional func negativeBtnTapped(klcPopup: KLCPopup?, messagePopupView: MessagePopupView)
}

class MessagePopupView: BaseUIView {
	@IBOutlet weak var icon: BaseUIButton!
    @IBOutlet weak var submitBtn: BaseUIButton!
	@IBOutlet weak var cancelBtn: BaseUIButton!
    @IBOutlet weak var titleLbl: BaseUILabel!
	@IBOutlet weak var titleBackground: BaseUIView!
	@IBOutlet var messLbl: UILabel!
	@IBOutlet var _heightConstraint: NSLayoutConstraint!
	weak var delegate: MessagePopupViewDelegate?
    var klcPopup: KLCPopup?

    var message: String = "" {
        didSet {
            messLbl.text = message
			messLbl.sizeToFit()

			if messLbl.frame.height > 67 {
				let oldFrame = self.frame
				_heightConstraint.constant = messLbl.frame.height + 133
				self.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: messLbl.frame.height + 133)
			}
        }
    }

	var isMultiSelection: Bool = false {
		didSet {
			cancelBtn.isHidden = !isMultiSelection
			submitBtn.setTitle("Yes", for: .normal)
			cancelBtn.setTitle("No", for: .normal)
		}
	}

    var title: String = "" {
        didSet {
            titleLbl.text = title
			if title == "Message" {
				//icon.setImage(UIImage(systemName: "info.circle"), for: .normal)
				//titleBackground.backgroundColor = UIColor(named: "midRed")
			} else if title == "Confirmation" {
				//icon.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
				//titleBackground.backgroundColor = UIColor("#3498DB")
			} else {
				//icon.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
				//titleBackground.backgroundColor = UIColor("#ED302F")
			}
        }
    }
    
    var buttonTitle: String = "" {
        didSet {
            submitBtn.setTitle(buttonTitle, for: .normal)
        }
    }

    @IBAction func submitClicked(_ sender: Any) {
        guard delegate != nil  else {
            self.klcPopup?.dismiss(true)
            return
        }
		delegate?.positiveBtnTapped?(klcPopup: klcPopup, messagePopupView: self)
    }

	@IBAction func cancelClicked(_ sender: Any) {
		guard delegate != nil  else {
			self.klcPopup?.dismiss(true)
			return
		}
		delegate?.negativeBtnTapped?(klcPopup: klcPopup, messagePopupView: self)
	}

	func setupTimer() {
		Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(dismissPopup), userInfo: nil, repeats: false)
	}

	@objc func dismissPopup() {
		if self.klcPopup?.isShowing ?? false {
			self.klcPopup?.dismiss(true)
		}
	}
}
