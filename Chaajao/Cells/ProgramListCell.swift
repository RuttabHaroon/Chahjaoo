//
//  ProgramListCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 14/09/2021.
//

import UIKit
@objc protocol ProgramListCellDelegate: AnyObject {
	@objc func tapped(cell: ProgramListCell)
}
class ProgramListCell: BaseUITableViewCell {
	@IBOutlet weak var baseView: BaseUIView!
	@IBOutlet weak var titleLabel: BaseUILabel!
	@IBOutlet weak var selectedButton: BaseUIButton!
	var delegate: ProgramListCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
		selectedButton.isUserInteractionEnabled = true
        // Initialization code
		baseView.isUserInteractionEnabled = true
		baseView.addTapGesture(tapNumber: 1, target: self, action: #selector(selected))
		selectedButton.addTapGesture(tapNumber: 1, target: self, action: #selector(selected))
		titleLabel.isUserInteractionEnabled = true
		titleLabel.addTapGesture(tapNumber: 1, target: self, action: #selector(selected))
    }

	@objc func selected() {
		if selectedButton.alpha == 1 {
			selectedButton.alpha = 0
		}
		delegate?.tapped(cell: self)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	override func updateData(_ data: Any?) {
		let dict = data as! [String:Any]
		titleLabel.text = dict["title"] as? String ?? ""
		selectedButton.alpha = (dict["selected"] as? Bool ?? false) ? 1 : 0
	}
}
