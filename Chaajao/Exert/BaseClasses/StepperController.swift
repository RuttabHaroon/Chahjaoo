//
//  StepperController.swift
//  Chaajao
//
//  Created by Ahmed Khan on 17/09/2021.
//

import Foundation
class StepperController: BaseCustomController {
	
	var currentStep = 1
	var steps: ([StepIndicatorView], [DottedLineView])!

	func addStepperView(parentView: BaseUIView, nSteps: Int) -> ([StepIndicatorView], [DottedLineView]) {
		let stepsWidth = 24 * nSteps
		var rowWidth: CGFloat = 0
		let nLines = nSteps - 1
		let paddingX:CGFloat = 40
		let linePaddingX:CGFloat = 8
		if UIDevice.current.orientation == .portrait {
			rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		} else if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) {
			rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		}
		rowWidth = rowWidth - paddingX
		rowWidth = rowWidth < parentView.frame.size.width ? rowWidth : parentView.frame.size.width
		rowWidth = rowWidth - CGFloat(stepsWidth) - (linePaddingX * CGFloat(nLines))
		let lineWidth = rowWidth/CGFloat(nLines)

		var steps = [StepIndicatorView]()
		var lines = [DottedLineView]()
		let stackView = UIStackView()

		stackView.spacing = 4
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fill

		for i in 0..<nSteps {
			let step = StepIndicatorView.loadNib() as! StepIndicatorView
			step.setupView(isCurrentStep: i == 0, stepNumber: i + 1)
			steps.append(step)
		}

		for _ in 0..<(nSteps - 1) {
			let line = getStepperLine(width: lineWidth)
//			if i == 0 {
//				line.backgroundColor = line.lineColor
//			}
			lines.append(line)
			line.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
			line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
		}

		for i in 0..<steps.count {
			stackView.addArrangedSubview(steps[i])
			if i < lines.count {
				let view = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: parentView.frame.size.height))
				view.addSubview(lines[i])
				_ = Constraints.leadingTrailingBottomTopToSuperView(subview: lines[i], superView: view, constant: 0, attriableValue: .leading)
				_ = Constraints.leadingTrailingBottomTopToSuperView(subview: lines[i], superView: view, constant: 0, attriableValue: .trailing)
				_ = Constraints.centerYToSuperView(subview: lines[i], superView: view)

				stackView.addArrangedSubview(view)
			}
		}
		parentView.addSubview(stackView)
		stackView.frame = parentView.frame
		stackView.fitInSuperView(parentView: parentView)
		return (steps, lines)
	}

	func getStepperLine(width: CGFloat) -> DottedLineView {
		let dottedLineView = DottedLineView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
		dottedLineView.lineWidth = 4
		dottedLineView.lineColor = UIColor(named: "yellowGradientEnd")!
		return dottedLineView
	}

	func goToNextStep() {
		guard currentStep < steps.0.count else {
			return
		}
		currentStep += 1
		for step in steps.0 {
			if step._stepNumber == currentStep {
				step.setupView(isCurrentStep: true, stepNumber: step._stepNumber)
			} else {
				step.setupView(isCurrentStep: false, stepNumber: step._stepNumber)
			}
		}

		for i in 0..<steps.1.count {
			if (currentStep - 1) <= i {
				steps.1[i].backgroundColor = .clear
			} else {
				steps.1[i].backgroundColor = UIColor(named: "yellowGradientEnd")!
			}
		}
		if let step = steps.0.first(where: {$0._stepNumber == currentStep - 1}) {
			step.setComplete(isComplete: true)
		}
	}

	func goToPreviousStep() {
		guard currentStep > 1 else {
			return
		}
		currentStep -= 1
		for step in steps.0 {
			if step._stepNumber == currentStep {
				step.setComplete(isComplete: false)
				step.setupView(isCurrentStep: true, stepNumber: step._stepNumber)
			} else {
				step.setupView(isCurrentStep: false, stepNumber: step._stepNumber)
			}
		}
		for i in 0..<steps.1.count {
			if (currentStep - 1) <= i {
				steps.1[i].backgroundColor = .clear
			} else {
				steps.1[i].backgroundColor = UIColor(named: "yellowGradientEnd")!
			}
		}
		if let step = steps.0.first(where: {$0._stepNumber == currentStep + 1}) {
			step.setComplete(isComplete: false)
		}
	}

	func restoreView(newSteps: ([StepIndicatorView], [DottedLineView])) {
		for i in 0..<self.steps.0.count {
			newSteps.0[i].setComplete(isComplete: self.steps.0[i]._isComplete)
			newSteps.0[i].setupView(isCurrentStep: self.steps.0[i]._isCurrentStep, stepNumber: self.steps.0[i]._stepNumber)
		}
		for i in 0..<self.steps.1.count {
			newSteps.1[i].backgroundColor = self.steps.1[i].backgroundColor
		}
		self.steps = newSteps
	}
}
