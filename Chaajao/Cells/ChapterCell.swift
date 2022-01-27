//
//  ChapterCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 22/09/2021.
//

import UIKit
@objc protocol ChapterCellDelegate : AnyObject {
	@objc func tapped(view: ChapterCell)
}

class ChapterCell: BaseUICollectionViewCell {
	@IBOutlet var button: BaseUIButton!
	var delegate: ChapterCellDelegate?
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		DispatchQueue.main.async(execute: {
			self.toggleButton(toggle: false)
		})
	}

	override func updateData(_ data: Any?) {
		if let data = data as? [String:Any] {
			let name = data["title"] as? String ?? ""
			button.setTitle(name, for: .normal)
			toggleButton(toggle: data["selected"] as? Bool ?? false)

		}
	}

	func toggleButton(toggle: Bool) {
		let oldFont = button.titleLabel?.font
		if toggle {
			button.setTitleColor(.white, for: .normal)
			button.setTitleColor(.white, for: .highlighted)
			button.setTitleColor(.white, for: .selected)
			button.setTitleColor(.white, for: .focused)
			button.isYellowGradient = true
			button.commontInit()
			button.titleLabel?.font = oldFont
		} else {
			button.setTitleColor(UIColor(named: "darkGray")!, for: .normal)
			button.setTitleColor(UIColor(named: "darkGray")!, for: .highlighted)
			button.isYellowGradient = false
			button.backgroundColor = .white
			button.commontInit()
			button.titleLabel?.font = oldFont
		}
	}

	@IBAction func tapped() {
		if button.titleColor(for: .normal) != .white {
			delegate?.tapped(view: self)
			toggleButton(toggle: true)
		}
	}
}
