
import UIKit


private let DefaultScalingAnimateDuration: TimeInterval = 1.0
private let DefaultAlphaAnimateDuration: TimeInterval   = 0.2
private let DefaultScale: CGFloat = 100
private var gradientLayer = CAGradientLayer()
open class BaseUIButton: UIButton {
	//MARK: - Properties
	static var viewName:String!{
		get {
			return "\(self)"
		}
	}

	open override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	/// Border Color Config
	@IBInspectable var borderColor: UIColor? {
		didSet {
			self.addBordeColor(color: borderColor)
		}
	}
	/// Border Width Config
	@IBInspectable open var borderWidth:CGFloat = 0 {
		didSet {
			self.addBorderWidth(width: borderWidth)
		}
	}

	@IBInspectable open var isRedGradient: Bool = false
	@IBInspectable open var isPinkGradient: Bool = false
	@IBInspectable open var isBlueGradient: Bool = false
	@IBInspectable open var isYellowGradient: Bool = false
	@IBInspectable open var isThumbnailGradient: Bool = false

	/// Corner radius rounded edges Config
	@IBInspectable open var cornerRadius:CGFloat = 0 {
		didSet {
			self.addRoundedCorners(ExertUtility.convertToRatio(cornerRadius));
		}
	}

	/// Flag for making circle/rounded view.
	@IBInspectable open var rounded:Bool = false {
		didSet {
			if rounded {
				self.addRoundedCorners();
			}
		}
	}

	/// Flag for Drop Shadow.
	@IBInspectable open var hasDropShadow:Bool = false {
		didSet {
			if (hasDropShadow) {
				self.addDropShadow();
			}
		}
	}
	/// Color for shadow
	@IBInspectable var shadowColor: UIColor? {
		didSet {
			if (!hasDropShadow) {
				self.addShadowColor(shadowColor: shadowColor);
			}
		}
	}

	/// Shadow opacity default 0, to range 1
	@IBInspectable var shadowOpacity: Float = 0.0 {
		didSet {
			if (!hasDropShadow) {
				self.addShadowOpacity(shadowOpacity: shadowOpacity)
			}
		}
	}

	/// The shadow offset
	@IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0){
		didSet {
			if (!hasDropShadow) {
				self.addShadowOffset(shadowOffset: shadowOffset)
			}
		}
	}

	/// The blur radius used to create the shadow.
	@IBInspectable var shadowRadius: Double = 0.0 {
		didSet {
			if (!hasDropShadow) {
				self.addShadowOffset(shadowOffset: shadowOffset)
			}
		}
	}

	//MARK: - Constructors

	/// Overridden constructor to setup/ initialize components.
	///
	/// - Parameter frame: View frame
	public override init(frame: CGRect) {
		super.init(frame: frame);
		//--
		self.commontInit();
	} //C.E.

	/// Required constructor implemented.
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}

	//MARK: - Overridden Methods

	/// Overridden method to setup/ initialize components.
	override open func awakeFromNib() {
		super.awakeFromNib()
		//--
		self.commontInit()
	} //F.E.
	func processGradient() {
		if isThumbnailGradient {
			self.applyGradient(colors: [UIColor.clear.cgColor, UIColor(named: "thumbnailGradient")!.cgColor], startPoint: CGPoint(x: 0.5, y: 0.3), endPoint: CGPoint(x: 0.5, y: 1.0))
		} else if isRedGradient {
			if rounded {
				self.applyGradient(colors: [UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "roundButtonGradientEnd")!.cgColor])
			} else {
				if (self.cornerRadius ) > 0 && self.cornerRadius != self.frame.height/2 {
					self.applyGradient(colors: [UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "squareRedGradientEnd")!.cgColor])
				} else {
					self.applyGradient(colors: [UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "redGradientStart")!.cgColor, UIColor(named: "redGradientEnd")!.cgColor])
				}
			}
		} else if isPinkGradient {
			if rounded {
				self.applyGradient(colors: [UIColor(named: "pinkGradientStart")!.cgColor, UIColor(named: "pinkGradientStart")!.cgColor, UIColor(named: "pinkGradientEnd")!.cgColor])
			} else {
				self.applyGradient(colors: [UIColor(named: "pinkGradientStart")!.cgColor, UIColor(named: "pinkGradientStart")!.cgColor, UIColor(named: "pinkGradientEnd")!.cgColor])
			}
		} else if isBlueGradient {
			if rounded {
				self.applyGradient(colors: [UIColor(named: "blueGradientStart")!.cgColor, UIColor(named: "blueGradientStart")!.cgColor, UIColor(named: "blueGradientEnd")!.cgColor])
			} else {
				self.applyGradient(colors: [UIColor(named: "blueGradientStart")!.cgColor, UIColor(named: "blueGradientStart")!.cgColor, UIColor(named: "blueGradientEnd")!.cgColor])
			}
		} else if isYellowGradient {
			if rounded {
				self.applyGradient(colors: [UIColor(named: "yellowGradientStart")!.cgColor, UIColor(named: "yellowGradientEnd")!.cgColor])
			} else {
				self.applyGradient(colors: [UIColor(named: "yellowGradientStart")!.cgColor, UIColor(named: "yellowGradientStart")!.cgColor, UIColor(named: "yellowGradientEnd")!.cgColor])
			}
		}
	}
	/// Overridden methed to update layout.
	override open func layoutSubviews() {
		super.layoutSubviews();
		//--
		processGradient()
		if !isRedGradient && !isBlueGradient && !isYellowGradient && !isPinkGradient && !isThumbnailGradient {
			self.layer.sublayers?.removeObject(gradientLayer)
			self.layoutIfNeeded()
			for layer in self.layer.sublayers ?? [CALayer]() {
				if layer is CAGradientLayer {
					self.layer.sublayers?.removeObject(layer)
				}
			}
		}
		if rounded {
			self.addRoundedCorners();
		}
		layer.cornerRadius = cornerRadius

	} //F.E.
	//MARK: - Methods

	/// Common initazier for setting up items.
	func commontInit() {
		self.isExclusiveTouch = true;
//		self.titleLabel?.font = self.titleLabel?.font.withSize(ExertUtility.convertToRatio((self.titleLabel?.font.pointSize)!))
		if cornerRadius > 0 {
			self.layer.cornerRadius = cornerRadius
		}
	} //F.E.
} //CLS END


//MARK GradientExtension
extension BaseUIButton {
	func applyGradient(colors: [CGColor]) {
		self.backgroundColor = .clear
		self.layer.sublayers?.removeObject(gradientLayer)
		self.layoutIfNeeded()
		for layer in self.layer.sublayers ?? [CALayer]() {
			if layer is CAGradientLayer {
				self.layer.sublayers?.removeObject(layer)
			}
		}
		gradientLayer = CAGradientLayer()
		gradientLayer.colors = colors
		let startPoint = rounded ? CGPoint(x: 0, y: 1) : CGPoint(x: 0, y: 0.5)
		let endPoint = rounded ? CGPoint(x: 1, y: 0) : CGPoint(x: 1, y: 0.5)
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
		gradientLayer.frame = self.bounds
		gradientLayer.cornerRadius = (self.cornerRadius ) == 0 ? self.frame.height/2 : self.cornerRadius
		self.cornerRadius = (self.cornerRadius ) == 0 ? self.frame.height/2 : self.cornerRadius

		gradientLayer.shadowColor = self.shadowColor?.cgColor
		gradientLayer.shadowOffset = self.shadowOffset
		gradientLayer.shadowRadius = CGFloat(self.shadowRadius)
		gradientLayer.shadowOpacity = self.shadowOpacity
		gradientLayer.masksToBounds = false
		self.layer.insertSublayer(gradientLayer, at: 0)
		self.contentVerticalAlignment = .center
		self.layoutIfNeeded()
	}

	func applyGradient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
		self.backgroundColor = .clear
		self.layer.sublayers?.removeObject(gradientLayer)
		self.layoutIfNeeded()
		for layer in self.layer.sublayers ?? [CALayer]() {
			if layer is CAGradientLayer {
				self.layer.sublayers?.removeObject(layer)
			}
		}
		gradientLayer = CAGradientLayer()
		gradientLayer.colors = colors
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
		gradientLayer.frame = self.bounds
		gradientLayer.cornerRadius = (self.cornerRadius ) == 0 ? self.frame.height/2 : self.cornerRadius
		self.cornerRadius = (self.cornerRadius ) == 0 ? self.frame.height/2 : self.cornerRadius

		gradientLayer.shadowColor = self.shadowColor?.cgColor
		gradientLayer.shadowOffset = self.shadowOffset
		gradientLayer.shadowRadius = CGFloat(self.shadowRadius)
		gradientLayer.shadowOpacity = self.shadowOpacity
		gradientLayer.masksToBounds = false
		self.layer.insertSublayer(gradientLayer, at: 0)
		self.contentVerticalAlignment = .center
		self.layoutIfNeeded()
	}
}
// MARK: - BaseUIButton - Ripple Animation Extension
public extension BaseUIButton {
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
		var completionHandler: ((BaseUIButton) -> Void)? = nil

		init(color: UIColor) {
			self.color = color
		}
	}

	func rippleAnimate(with config: BaseUIButton.RippleConfiguration, completionHandler: ((BaseUIButton) -> Void)?) {
		clipsToBounds = config.clipsToBounds
		let startRect = config.startRect ?? rippleDefaultStartRect

		rippleAnimate(with: config.color, scale: DefaultScale, startRect: startRect, scaleAnimateDuration: config.scaleAnimateDuration, fadeAnimateDuration: config.fadeAnimateDuration, completionHandler: completionHandler)

	}
	func resetProperties(oldSelf: BaseUIButton) {
		self.shadowOpacity = oldSelf.shadowOpacity
		self.shadowColor = oldSelf.shadowColor
		self.shadowOffset = oldSelf.shadowOffset
		self.rounded = oldSelf.rounded
		self.hasDropShadow = oldSelf.hasDropShadow
		self.cornerRadius = oldSelf.cornerRadius
		self.shadowRadius = oldSelf.shadowRadius
		//self.layer.shadowRadius = CGFloat(oldSelf.shadowRadius)
		self.layer.cornerRadius = oldSelf.cornerRadius
	}

	// swiftlint:disable function_parameter_count
	private func rippleAnimate(with color: UIColor, scale: CGFloat, startRect: CGRect, scaleAnimateDuration: TimeInterval, fadeAnimateDuration: TimeInterval, completionHandler: ((BaseUIButton) -> Void)?) {
		let originalSelf = self
		DispatchQueue.main.async {
			//let originalState = self
			let rippleView = RippleView(frame: startRect, backgroundColor: color)
			self.addSubview(rippleView)

			let scaleAnimation = {
				let widthRatio = self.frame.width / rippleView.frame.width
				rippleView.transform = CGAffineTransform(scaleX: widthRatio * scale, y: widthRatio * scale)
			}

			let fadeAnimation = { rippleView.alpha = 0.0 }

			// start scale animation
			BaseUIButton.animate(withDuration: scaleAnimateDuration, animations: scaleAnimation, completion: { completion in

				guard completion else { return }

				// start fade animation
				BaseUIButton.animate(withDuration: fadeAnimateDuration, animations: fadeAnimation, completion: { completion in
					guard completion else { return }
					rippleView.removeFromSuperview()
					completionHandler?(originalSelf)
				})
			})
		}
	}
	// swiftlint:enable function_parameter_count
}

/// Custom BaseUIView for ripple effects
private final class RippleView: BaseUIButton {

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
