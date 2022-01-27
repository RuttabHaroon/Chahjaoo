//
//  BaseUIActivityIndicatorView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 05/09/2021.
//

import Foundation

open class BaseUIActivityIndicatorView: UIActivityIndicatorView {

	@IBInspectable var scaleFactor: CGFloat = 0

	open override func layoutSubviews() {
		super.layoutSubviews()
		if scaleFactor != 0 {
			applyScaleFactor()
		}
	}
	func applyScaleFactor() {
		transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
	}
}
