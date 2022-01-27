//
//  CircularProgressBar.swift
//  Chaajao
//  Original Gist: https://gist.github.com/yogeshmanghnani/d73ad00eed7b3b55784c0d24e9852332#file-circularprogressbar-swift
//  Created by Yogesh Manghnani on 02/05/18.
//  Copyright © 2018 Yogesh Manghnani. All rights reserved.
//

import UIKit


class CircularProgressBar: UIView {

	//MARK: awakeFromNib

	override func awakeFromNib() {
		super.awakeFromNib()
		setupView()
		label.text = value
	}

	//MARK: Public

	public var lineWidth:CGFloat = ExertUtility.convertToRatio(8) > 8 ? 8 : ExertUtility.convertToRatio(8) {
		didSet{
			foregroundLayer.lineWidth = lineWidth
			backgroundLayer.lineWidth = lineWidth * 0.6
		}
	}
	@IBInspectable var progress: Double = 0
	@IBInspectable var value: String = "00" {
		didSet {
			setLabel(newValue: value)
		}
	}

	@IBInspectable var hasTwoRings : Bool = false

	@IBInspectable var secondRingProgress: Double = 0

	func setLabel(newValue: String) {
		label.text = newValue
	}
	
	var lineBackgroundColor = UIColor(named: "progressCircleBackground")
	var lineColor: UIColor?
	var fillColor = UIColor.clear.cgColor
	var topFillColor = UIColor.clear.cgColor

	public var labelSize: CGFloat = 20 {
		didSet {
			label.font = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: EXERT_GLOBAL.SIZE_BOLD)
			label.sizeToFit()
			configLabel()
		}
	}

	public func setProgress(to progressConstant: Double, withAnimation: Bool, topProgressConstant: Double = 0) {
		var progress: Double {
			get {
				if progressConstant > 1 { return 1 }
				else if progressConstant < 0 { return 0 }
				else { return progressConstant }
			}
		}
		var topProgress: Double {
			get {
				if topProgressConstant > 1 { return 1 }
				else if topProgressConstant < 0 { return 0 }
				else { return topProgressConstant }
			}
		}

		foregroundLayer.strokeEnd = CGFloat(progress)
		topForegroundLayer.strokeEnd = CGFloat(topProgress)
		if withAnimation {
			let maxDuration = 3.0
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = 0
			animation.toValue = progress
			animation.duration = maxDuration * progress
			foregroundLayer.add(animation, forKey: "foregroundAnimation")
			if hasTwoRings {
				let animationTop = CABasicAnimation(keyPath: "strokeEnd")
				animationTop.fromValue = 0
				animationTop.toValue = topProgress
				animationTop.duration = maxDuration * progress
				topForegroundLayer.add(animationTop, forKey: "foregroundAnimation")
			}
		}

		var currentTime:Double = 0
		let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
			if currentTime >= 2{
				timer.invalidate()
			} else {
				currentTime += 0.05
				self.configLabel()
			}
		}
		timer.fire()
	}

	//MARK: Private
	private var label = BaseUILabel()
	let topForegroundLayer = CAShapeLayer()
	let foregroundLayer = CAShapeLayer()
	let backgroundLayer = CAShapeLayer()
	private var radius: CGFloat {
		get{
			if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
			else { return (self.frame.height - lineWidth)/2 }
		}
	}

	private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
	private func makeBar(){
		self.layer.sublayers = nil
		drawBackgroundLayer()
		drawForegroundLayer()
		drawTopForegroundLayer()
	}

	private func drawBackgroundLayer(){
		let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
		self.backgroundLayer.path = path.cgPath
		self.backgroundLayer.strokeColor = lineBackgroundColor?.cgColor
		self.backgroundLayer.lineWidth = lineWidth * 0.6
		self.backgroundLayer.fillColor = fillColor
		self.layer.addSublayer(backgroundLayer)

	}

	private func drawForegroundLayer() {
		self.layer.sublayers?.removeObject(foregroundLayer)
		let startAngle = (-CGFloat.pi/2)
		let endAngle = 2 * CGFloat.pi + startAngle

		let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

		foregroundLayer.lineCap = CAShapeLayerLineCap.round
		foregroundLayer.path = path.cgPath
		foregroundLayer.lineWidth = lineWidth
		foregroundLayer.fillColor = fillColor
		foregroundLayer.strokeEnd = 0

		self.layer.addSublayer(foregroundLayer)
	}

	private func drawTopForegroundLayer() {
		self.layer.sublayers?.removeObject(topForegroundLayer)
		let startAngle = (-CGFloat.pi/2)
		let endAngle = 2 * CGFloat.pi + startAngle
		let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

		topForegroundLayer.lineCap = CAShapeLayerLineCap.round
		topForegroundLayer.path = path.cgPath
		topForegroundLayer.lineWidth = lineWidth * 1.2
		topForegroundLayer.fillColor = topFillColor
		topForegroundLayer.strokeEnd = 0

		self.layer.addSublayer(topForegroundLayer)
	}

	private func makeLabel(withText text: String) -> UILabel {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		label.text = value
		label.sizeToFit()
		label.center = pathCenter
		label.font = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: EXERT_GLOBAL.SIZE_BOLD)
		return label
	}

	private func configLabel(){
		label.sizeToFit()
		label.center = pathCenter
		label.font = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: EXERT_GLOBAL.SIZE_BOLD)
	}

	private func setupView() {
		makeBar()
		self.addSubview(label)
	}
	
	//Layout Sublayers

	private var layoutDone = false
	override func layoutSublayers(of layer: CALayer) {
		if !layoutDone {
			let tempText = label.text
			setupView()
			label.text = tempText
			label.font = UIFont(name: EXERT_GLOBAL.GORDITA_BOLD, size: EXERT_GLOBAL.SIZE_BOLD)
			layoutDone = true
		}
	}
}
