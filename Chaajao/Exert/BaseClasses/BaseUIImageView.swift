
import UIKit
private let DefaultScalingAnimateDuration: TimeInterval = 1.0
private let DefaultAlphaAnimateDuration: TimeInterval   = 0.2
private let DefaultScale: CGFloat = 100
open class BaseUIImageView: UIImageView {
    //MARK: - Properties
    static var viewName:String!{
        get {
            return "\(self)"
        }
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
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.clipsToBounds = true;
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
    
} //CLS END

// MARK: - BaseUIImageView - Ripple Animation Extension
public extension BaseUIImageView {
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
		var completionHandler: ((BaseUIImageView) -> Void)? = nil

		init(color: UIColor) {
			self.color = color
		}
	}

	func rippleAnimate(with config: BaseUIImageView.RippleConfiguration, completionHandler: ((BaseUIImageView) -> Void)?) {
		clipsToBounds = config.clipsToBounds
		let startRect = config.startRect ?? rippleDefaultStartRect

		rippleAnimate(with: config.color, scale: DefaultScale, startRect: startRect, scaleAnimateDuration: config.scaleAnimateDuration, fadeAnimateDuration: config.fadeAnimateDuration, completionHandler: completionHandler)

	}
	func resetProperties(oldSelf: BaseUIImageView) {
		self.shadowOpacity = oldSelf.shadowOpacity
		self.shadowColor = oldSelf.shadowColor
		self.shadowOffset = oldSelf.shadowOffset
		self.rounded = oldSelf.rounded
		self.hasDropShadow = oldSelf.hasDropShadow
		self.cornerRadius = oldSelf.cornerRadius
		self.shadowRadius = oldSelf.shadowRadius
		self.layer.shadowRadius = CGFloat(oldSelf.shadowRadius)
		self.layer.cornerRadius = oldSelf.cornerRadius
	}

	// swiftlint:disable function_parameter_count
	private func rippleAnimate(with color: UIColor, scale: CGFloat, startRect: CGRect, scaleAnimateDuration: TimeInterval, fadeAnimateDuration: TimeInterval, completionHandler: ((BaseUIImageView) -> Void)?) {
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
			BaseUIImageView.animate(withDuration: scaleAnimateDuration, animations: scaleAnimation, completion: { completion in

				guard completion else { return }

				// start fade animation
				BaseUIImageView.animate(withDuration: fadeAnimateDuration, animations: fadeAnimation, completion: { completion in
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
private final class RippleView: BaseUIImageView {

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
