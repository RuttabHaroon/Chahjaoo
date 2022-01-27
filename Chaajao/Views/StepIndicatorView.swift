//
//  StepIndicatorView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 16/09/2021.
//

import UIKit

class StepIndicatorView: BaseUIView {

	@IBOutlet var midLayer: BaseUIButton!
	@IBOutlet var topLayer: BaseUIButton!
	@IBOutlet var midLayerBg: BaseUIView!
	@IBOutlet var topLayerBg: BaseUIView!
	var _stepNumber = 0
	var _isCurrentStep = false
	var _isComplete = false

	func setupView(isCurrentStep: Bool, stepNumber: Int) {
		_isCurrentStep = isCurrentStep
		_stepNumber = stepNumber
		if !_isComplete {
			if _isCurrentStep {
				topLayer.setTitle(String(_stepNumber), for: .normal)
				topLayer.isHidden = false
				topLayerBg.isHidden = false
			} else {
				midLayer.setTitle(String(_stepNumber), for: .normal)
				midLayer.isHidden = false
				midLayerBg.isHidden = false
				topLayer.isHidden = true
				topLayerBg.isHidden = true
			}
		}
	}

	func setComplete(isComplete: Bool) {
		_isComplete = isComplete
		if _isComplete {
			topLayer.isHidden = false
			topLayerBg.isHidden = false
			midLayerBg.isHidden = true
			topLayer.setTitle("", for: .normal)
			topLayer.setImage(UIImage(named: "checkmark"), for: .normal)
		} else {
			topLayer.isHidden = true
			topLayerBg.isHidden = true
			midLayerBg.isHidden = false
			topLayer.setTitle(String(_stepNumber), for: .normal)
			topLayer.setImage(nil, for: .normal)
		}
	}
}
