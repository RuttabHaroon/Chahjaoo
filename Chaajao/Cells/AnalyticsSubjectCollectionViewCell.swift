//
//  AnalyticsSubjectCollectionViewCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 29/09/2021.
//

import UIKit

@objc protocol AnalyticsSubjectCollectionViewCellDelegate : AnyObject {
	@objc func itemTapped(cell: AnalyticsSubjectCollectionViewCell)
}

class AnalyticsSubjectCollectionViewCell: BaseUICollectionViewCell {
	@IBOutlet var baseView: BaseUIView!
	@IBOutlet var icon: UIButton!
	@IBOutlet var titleLabel: BaseUILabel!
	var model : AnalyticsSubjectPickerModel?
	let selectedColor = UIColor(named:"boxBorder")!
	var delegate: AnalyticsSubjectCollectionViewCellDelegate!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func updateData(_ data: Any?) {
		model = data as? AnalyticsSubjectPickerModel

//		icon.setImage(UIImage(named: "Navigation.Menu"), for: .normal)
		titleLabel.text = model?.name
		setSelected(toggle: model?.isSelected ?? false)
	}

	func setSelected(toggle: Bool) {
		baseView.backgroundColor = toggle ? selectedColor : .clear
	}

	@IBAction func buttonTapped() {
		if baseView.backgroundColor != selectedColor {
			setSelected(toggle: true)
			delegate.itemTapped(cell: self)
		}
	}
}
