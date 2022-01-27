//
//  NotificationCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 11/09/2021.
//

import UIKit

class NotificationCell: BaseUITableViewCell {

	@IBOutlet weak var titleLabel: BaseUILabel!
	@IBOutlet weak var descriptionLabel: BaseUILabel!
	@IBOutlet weak var icon: BaseUIButton!
	@IBOutlet weak var background: BaseUIView!
	@IBOutlet weak var topBorder: BaseUIView!
	@IBOutlet weak var bottomBorder: BaseUIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	override func updateData(_ data: Any?) {
		let dict = data as! [String:Any]

		titleLabel.text = dict["title"] as? String ?? ""
		descriptionLabel.text = dict["description"] as? String ?? ""

		if let iconName = dict["iconName"] as? String, iconName != "" {
			icon.setImage(UIImage(named: iconName), for: .normal)
		}
		if dict["read"] as? Bool ?? false {
			contentView.backgroundColor = EXERT_GLOBAL.readNotification
			background.backgroundColor = EXERT_GLOBAL.readNotification
		} else {
			contentView.backgroundColor = .white
			background.backgroundColor = .white
		}
		topBorder.isHidden = dict["isFirst"] as? Bool ?? false
		bottomBorder.isHidden = dict["isLast"] as? Bool ?? false
	}
}
