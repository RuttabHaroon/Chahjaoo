//
//  UIView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 23/06/2021.
//  Copyright © 2021 TechSurge Inc. All rights reserved.
//

import UIKit

private let DefaultScalingAnimateDuration: TimeInterval = 1.0
private let DefaultAlphaAnimateDuration: TimeInterval   = 0.2
private let DefaultScale: CGFloat = 100

public extension UIView {

	fileprivate var rippleDefaultStartRect: CGRect {
		return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
	}

	struct RippleConfiguration {
		var color: UIColor
		var clipsToBounds = false
		var startRect: CGRect? = nil
		var scale: CGFloat = DefaultScale
		var scaleAnimateDuration = DefaultScalingAnimateDuration
		var fadeAnimateDuration = DefaultAlphaAnimateDuration
		var completionHandler: ((UIView) -> Void)? = nil

		init(color: UIColor) {
			self.color = color
		}
	}

	func rippleAnimate(with config: UIView.RippleConfiguration, completionHandler: ((UIView) -> Void)?) {

		clipsToBounds = config.clipsToBounds
		let startRect = config.startRect ?? rippleDefaultStartRect

		rippleAnimate(with: config.color, scale: DefaultScale, startRect: startRect, scaleAnimateDuration: config.scaleAnimateDuration, fadeAnimateDuration: config.fadeAnimateDuration, completionHandler: completionHandler)
	}

	// swiftlint:disable function_parameter_count
	private func rippleAnimate(with color: UIColor, scale: CGFloat, startRect: CGRect, scaleAnimateDuration: TimeInterval, fadeAnimateDuration: TimeInterval, completionHandler: ((UIView) -> Void)?) {
		let originalSelf = self
		DispatchQueue.main.async {
			let rippleView = RippleView(frame: startRect, backgroundColor: color)
			self.addSubview(rippleView)

			let scaleAnimation = {
				let widthRatio = self.frame.width / rippleView.frame.width
				rippleView.transform = CGAffineTransform(scaleX: widthRatio * scale, y: widthRatio * scale)
			}

			let fadeAnimation = { rippleView.alpha = 0.0 }

			// start scale animation
			UIView.animate(withDuration: scaleAnimateDuration, animations: scaleAnimation, completion: { completion in

				guard completion else { return }

				// start fade animation
				DispatchQueue.main.async {
					UIView.animate(withDuration: fadeAnimateDuration, animations: fadeAnimation, completion: { completion in
						guard completion else { return }
						rippleView.removeFromSuperview()
						completionHandler?(originalSelf)
					})
				}
			})
		}
	}
	// swiftlint:enable function_parameter_count
}

/// Custom UIView for ripple effects
private final class RippleView: UIView {

	init(frame: CGRect, backgroundColor: UIColor) {
		super.init(frame: frame)
		self.backgroundColor = backgroundColor
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func draw(_ rect: CGRect) {
		let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
		let maskLayer = CAShapeLayer()
		maskLayer.path = maskPath.cgPath
		layer.mask = maskLayer
	}

}
