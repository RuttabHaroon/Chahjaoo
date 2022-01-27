//
//  TestCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 22/09/2021.
//

import UIKit
@objc protocol TestCellDelegate : AnyObject {
	@objc func tapped(cell: TestCell)
	@objc func reportTapped(cell: TestCell)
	@objc func redoTapped(cell: TestCell)
	@objc func lockTapped(cell: TestCell)
    @objc func tapped(cell:TestCell, testID: Int)
}

class TestCell: BaseUITableViewCell {

	@IBOutlet var title: BaseUILabel!
	@IBOutlet var subTitle: BaseUILabel!
	@IBOutlet var button: BaseUIButton!
	@IBOutlet var redoTest: BaseUIButton!
	@IBOutlet var topSeparator: UIView!
	@IBOutlet var bottomSeparator: UIView!
	var delegate: TestCellDelegate?
	var icon = "PadLock.Filled"
    var testID = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	override func updateData(_ data: Any?) {
		let obj = data as! [String : Any]

		let titleValue = obj["title"] as? String ?? ""
		icon = obj["icon"] as? String ?? "PadLock.Filled"
		let topSeparatorValue = obj["topSeparator"] as? Bool ?? false
		let bottomSeparatorValue = obj["bottomSeparator"] as? Bool ?? false
		let subTitleValue = obj["subTitle"] as? String ?? ""
		let redoTestHidden = obj["redoTestHidden"] as? Bool ?? false

        testID = obj["testID"] as? Int ?? 0
        
		topSeparator.isHidden = !topSeparatorValue
		bottomSeparator.isHidden = !bottomSeparatorValue
		title.text = titleValue
		subTitle.text = subTitleValue
		redoTest.isHidden = redoTestHidden
		button.setImage(UIImage(named: icon), for: .normal)
		if icon == "Performance.Report" {
			button.tintColor = UIColor(named: "midRed")
		}
//		button.isUserInteractionEnabled = icon != "PadLock.Filled"
	}

	@IBAction func tapped() {
		if icon == "PadLock.Filled" {
			delegate?.lockTapped(cell: self)
		} else {
			if icon == "Performance.Report" {
				delegate?.reportTapped(cell: self)
			} else {
				//delegate?.tapped(cell: self)
                delegate?.tapped(cell: self, testID: testID)
			}
		}
	}

	@IBAction func redoTapped() {
		delegate?.redoTapped(cell: self)
	}
}
