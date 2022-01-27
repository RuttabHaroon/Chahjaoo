//
//  SubjectCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 15/09/2021.
//

import UIKit

@objc protocol SubjectCellDelegate: AnyObject {
	@objc func itemTapped(cell: SubjectCell)
}

class SubjectCell: BaseUICollectionViewCell {
	@IBOutlet var baseView: BaseUIView!
	@IBOutlet var icon: UIButton!
	@IBOutlet var titleLabel: BaseUILabel!
	@IBOutlet var selectedButton: BaseUIView!
	@IBOutlet var checkTon: UIButton!
	var delegate: SubjectCellDelegate!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func updateData(_ data: Any?) {
		let model = data as! SubjectPickerModel
		icon.setImage(UIImage(named: "Navigation.Menu"), for: .normal)
		titleLabel.text = model.name
		setSelected(toggle: model.isSelected)
	}

	func setSelected(toggle: Bool) {
		if toggle {
			baseView.borderColor = UIColor(named: "midRed")
			baseView.borderWidth = 2
			checkTon.isHidden = false
			selectedButton.isHidden = false
		} else {
			baseView.borderWidth = 0
			baseView.borderColor = .white
			checkTon.isHidden = true
			selectedButton.isHidden = true
		}
	}

	@IBAction func buttonTapped() {
		if baseView.borderColor != UIColor(named: "midRed") {
			setSelected(toggle: true)
			delegate.itemTapped(cell: self)
		}
	}
}
