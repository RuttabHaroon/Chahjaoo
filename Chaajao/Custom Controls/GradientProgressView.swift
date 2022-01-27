//
//  GradientProgressView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 23/09/2021.
//

import UIKit

class GradientProgressView: UIProgressView {

	@IBInspectable var firstColor: UIColor = UIColor.white {
		didSet {
			updateView()
		}
	}

	@IBInspectable var secondColor: UIColor = UIColor.black {
		didSet {
			updateView()
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		subviews.forEach { subview in
			subview.layer.masksToBounds = true
			subview.layer.cornerRadius = self.frame.height / 2
		}
	}

	func updateView() {

		if let gradientImage = UIImage(bounds: self.bounds, colors: [firstColor, secondColor]) {
			self.progressImage = gradientImage
		}
	}
}
