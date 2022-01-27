//
//  PackageCollectionViewCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 17/09/2021.
//

import UIKit

@objc protocol PackageCollectionViewCellDelegate: AnyObject {
	@objc func selected(cell: PackageCollectionViewCell)
}
class PackageCollectionViewCell: BaseUIView {
	@IBOutlet var name: BaseUILabel!
	@IBOutlet var price: BaseUILabel!
	@IBOutlet var features: UIStackView!
	@IBOutlet var baseView: BaseUIView!
	@IBOutlet var featuresHeightConstraint: NSLayoutConstraint!
	@IBOutlet var button: BaseUIButton!
	var delegate: PackageCollectionViewCellDelegate?
	var model: PackageModel!
	var newHeight: CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		features.spacing = 20
    }

	func setSize(new: CGSize) {
		self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: new.width, height: new.height)
//		self.newHeight = self.frame.height
	}

	func updateBtn(_ data: Any?) {
		model = data as? PackageModel
		self.toggleButton(selected: self.model.selected)
	}

	func updateData(_ data: Any?) {
		model = data as? PackageModel
		name.text = model.name
		price.text = model.price
		var height = CGFloat(0)
		self.featuresHeightConstraint.constant = CGFloat((model.features.count * 20) + ((model.features.count - 1) * 20))
		self.features.removeAllSubviews()
		DispatchQueue.main.async(execute: {
			for feature in self.model.features {
				let view = self.getFeature(description: feature)
				height += view.frame.height
				height += 20
				self.features.addArrangedSubview(view)
			}
			height -= 20
			if self.featuresHeightConstraint.constant > height {
				let delta = self.featuresHeightConstraint.constant - height
				self.featuresHeightConstraint.constant = self.featuresHeightConstraint.constant - delta
			} else if self.featuresHeightConstraint.constant < height {
				let delta = height - self.featuresHeightConstraint.constant
				self.featuresHeightConstraint.constant = self.featuresHeightConstraint.constant + delta
			}
			self.toggleButton(selected: self.model.selected)
		})
	}

	func onUpdate()-> Bool {
		if button.titleLabel?.text == "SELECTED" {
			return true
		} else if button.titleLabel?.text == "SELECT" {
			toggleButton(selected: true)
			return true
		}
		return false
	}

	@IBAction func tapped() {
		if onUpdate() {
			delegate?.selected(cell: self)
		}
	}

	func toggleButton(selected: Bool) {
		let oldFont = button.titleLabel?.font
		if selected {
			button.setTitle("SELECTED", for: .normal)
			button.setTitleColor(.white, for: .normal)
			button.setTitleColor(.white, for: .selected)
			button.isBlueGradient = true
			button.commontInit()
			button.titleLabel?.font = oldFont
			button.borderWidth = 0
		} else {
			button.setTitle("SELECT", for: .normal)
			button.setTitleColor(UIColor(named: "blueGradientStart")!, for: .normal)
			button.setTitleColor(UIColor(named: "blueGradientStart")!, for: .selected)
			button.isBlueGradient = false
			button.borderWidth = 1
			button.cornerRadius = button.frame.height/2
			button.backgroundColor = .white
			button.commontInit()
			button.titleLabel?.font = oldFont
		}
	}

	func getFeature(description: String)->UIView {
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
		imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true

		//Hollow.Checkmark
		imageView.image = UIImage(named: "Selected.Circle")
		imageView.contentMode = .scaleAspectFit
		let title = BaseUILabel(frame: CGRect(x: 0, y: 0, width: 0, height: imageView.frame.size.height))
		title.font = UIFont(name: EXERT_GLOBAL.fontName, size: CGFloat(10))
		title.lineBreakMode = .byWordWrapping
		title.numberOfLines = 0
		title.text = description
		title.frame = CGRect(x: 0, y: 0, width: title.frame.width, height: imageView.frame.size.height)
		let view = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + title.frame.width, height: imageView.frame.size.height))
		view.addSubview(imageView)
		view.addSubview(title)

		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: imageView, superView: view, constant: 0, attriableValue: .leading)
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: imageView, superView: view, constant: 0, attriableValue: .top)

		if title.frame.height <= imageView.frame.height {
			_ = Constraints.leadingTrailingBottomTopToSuperView(subview: imageView, superView: view, constant: 0, attriableValue: .bottom)
			title.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
		} else {
			title.centerYAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
		}

		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: title, superView: view, constant: 0, attriableValue: .trailing)
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: title, superView: view, constraintTo: imageView, constant: 5, attriableValue: .leading, attriableTo: .trailing)
		title.sizeToFit()
		view.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
		return view
	}
}
