//
//  SingleButtonFooter.swift
//  Chaajao
//
//  Created by Ahmed Khan on 06/10/2021.
//

import UIKit

@objc protocol SingleButtonFooterDelegate : AnyObject {
	@objc func buttonTapped(cell: SingleButtonFooter)
}

class SingleButtonFooter: BaseUITableViewCell {
	@IBOutlet var btn: BaseUIButton!
	var delegate: SingleButtonFooterDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	override func updateData(_ data: Any?) {
		super.updateData(data)
		if let data = data as? [String: Any] {
			btn.setTitle(data["title"] as? String ?? "OK" , for: .normal)
			btn.isUserInteractionEnabled = data["isUserInteractionEnabled"] as? Bool ?? true
		}
	}

	@IBAction func buttonTapped() {
		delegate?.buttonTapped(cell: self)
	}
}
