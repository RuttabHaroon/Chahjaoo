//
//  BankCollectionCell.swift
//  CDC
//
//  Created by Ahmed Khan on 27/06/2020.
//  Copyright © 2020-21 TechSurge Inc. All rights reserved.
//

import UIKit
@objc protocol BankCollectionCellDelegate: AnyObject {
	@objc func itemTapped(cell: BankCollectionCell)
}
class BankCollectionCell: BaseUICollectionViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var button: BaseUIButton!
	@IBOutlet var titleLabel: BaseUILabel!
	@IBOutlet var baseView: BaseUIView!
	@IBOutlet var selectedButton: BaseUIView!
	@IBOutlet var checkTon: UIButton!
	var delegate: BankCollectionCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func updateData(_ data: Any?) {
		let model = data as! CoursePickerModel
		icon.image = UIImage(named: model.iconName)
		titleLabel.text = model.instituteName
		setSelected(toggle: model.isSelected)
	}

	func setSelected(toggle: Bool) {
		if toggle {
			baseView.borderColor = UIColor(named: "midRed")
			baseView.borderWidth = 2
			baseView.shadowColor = .black
			baseView.shadowOffset = CGSize(width: 1, height: -1)
			baseView.shadowOpacity = 0.2
			checkTon.isHidden = false
			selectedButton.isHidden = false
		} else {
			baseView.borderWidth = 1
			baseView.borderColor = UIColor(named: "boxBorder")
			selectedButton.isHidden = true
			checkTon.isHidden = true
			baseView.shadowOpacity = 0
		}
	}

	@IBAction func buttonTapped() {
		if baseView.borderColor != UIColor(named: "midRed") {
			setSelected(toggle: true)
			delegate.itemTapped(cell: self)
		}
	}
}
