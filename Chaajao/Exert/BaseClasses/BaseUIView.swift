
import UIKit

// BaseUIView is a subclass of UIView. Add sone more designable properties to view.
open class BaseUIView: UIView {
    
    //MARK: - Properties
    static var viewName:String!{
        get {
            return "\(self)"
        }
    }
	var dashedLayer:CAShapeLayer = CAShapeLayer()
    
    static func loadNib() -> UIView {
        return BaseUIView.loadWithNib(viewName, viewIndex:0, owner:self) as! UIView
    }
    
    lazy var tapgesture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureClicked))
        return gesture
    }()
    
    @objc func handleTapGestureClicked(gesture: UITapGestureRecognizer) {
        
    }
    
     func addView(superView: UIView) {
        if !self.isDescendant(of: superView) {
			superView.addSubview(self)
            _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: superView, constant: 0, attriableValue: .leading)
            _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: superView, constant: 0, attriableValue: .trailing)
            
            _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: superView, constant: 0, attriableValue: .top)
            
            _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: superView, constant: 0, attriableValue: .bottom)
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

	@IBInspectable open var dashedBorder: Bool = false
	func addDashedBorder() {
		let color = borderColor
		self.layer.sublayers?.removeObject(dashedLayer)
		self.layoutIfNeeded()
		for layer in self.layer.sublayers ?? [CALayer]() {
			if layer is CAShapeLayer {
				self.layer.sublayers?.removeObject(layer)
			}
		}

		let frameSize = self.frame.size
		let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

		dashedLayer.bounds = shapeRect
		dashedLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
		dashedLayer.fillColor = UIColor.clear.cgColor
		dashedLayer.strokeColor = color?.cgColor
		dashedLayer.lineWidth = 1
		dashedLayer.lineJoin = CAShapeLayerLineJoin.round
		dashedLayer.lineDashPattern = [3,3]
		dashedLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

		self.layer.addSublayer(dashedLayer)
	}
    /// Corner radius rounded edges Config
    @IBInspectable open var cornerRadius:CGFloat = 0 {
        didSet {
            self.addRoundedCorners(ExertUtility.convertToRatio(cornerRadius));
        }
    }
    
    @IBInspectable open var isHexagonView:Bool = false {
        didSet {
            self.setupHexagonView()
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
        super.awakeFromNib()
//		if cornerRadius > 0 {
//			cornerRadius = ExertUtility.isIPad ? cornerRadius * 0.666 : cornerRadius
//			layer.cornerRadius = cornerRadius
//		}
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
		if dashedBorder {
			addDashedBorder()
		}
    } //F.E.
    
} //CLS END

extension BaseUIView{
	func animShow(){
		UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
					   animations: {
						self.center.y -= self.bounds.height
						self.layoutIfNeeded()
					   }, completion: nil)
		self.isHidden = false
	}
	func animHide(){
		UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
					   animations: {
						self.center.y += self.bounds.height
						self.layoutIfNeeded()

					   },  completion: {(_ completed: Bool) -> Void in
						self.isHidden = true
					})
	}
}
