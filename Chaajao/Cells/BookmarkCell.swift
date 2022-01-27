//
//  BookmarkCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/10/2021.
//

import UIKit

class BookmarkCell: BaseUITableViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var categoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	override func updateData(_ data: Any?) {
		super.updateData(data)

		let data = data as! [String:Any]

		titleLabel.text = "Q. \(data["title"] as? String ?? "")"
		categoryLabel.text = data["category"] as? String ?? ""
	}
}
