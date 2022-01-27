
import UIKit

/// BaseUILabel is a subclass of UILabel
open class BaseUILabel: UILabel {
    
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

	@IBInspectable open var miscTag: String = ""
	@IBInspectable open var boldText: String = ""
	@IBInspectable open var italicText: String = ""

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
//    /// Color for shadow
//    @IBInspectable open var shadowColor: UIColor? {
//        didSet {
//            if (!hasDropShadow) {
//                self.addShadowColor(shadowColor: shadowColor);
//            }
//        }
//    }
    
//    /// Shadow opacity default 0, to range 1
//    @IBInspectable var shadowOpacity: Float = 0.0 {
//        didSet {
//            if (!hasDropShadow) {
//                self.addShadowOpacity(shadowOpacity: shadowOpacity)
//            }
//        }
//    }
    
//    /// The shadow offset
//    @IBInspectable open var shadowOffset: CGSize{
//        didSet {
//            if (!hasDropShadow) {
//                self.addShadowOffset(shadowOffset: shadowOffset)
//            }
//        }
//    }
    
    /// The blur radius used to create the shadow.
    @IBInspectable var shadowRadius: Double = 0.0 {
        didSet {
            if (!hasDropShadow) {
                self.addShadowOffset(shadowOffset: shadowOffset)
            }
        }
    }
    
    @IBInspectable open var underlinedText:Bool = false {
        didSet {
            if (underlinedText) {
                let attString:NSMutableAttributedString=NSMutableAttributedString(string: (self.text)! as String)
                attString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: NSRange(location: 0, length: attString.length))
                self.attributedText = attString
            } else {
                // TO HANDLER
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
//        self.commontInit();
    } //C.E.

    /// Required method implemented
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.

    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.

    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        //Referesh on update layout
        if rounded {
            self.rounded = true;
        }
    } //F.E.

    //MARK: - Methods
    
    /// Common initazier for setting up items.
    private func commontInit() {
//		self.font = font?.withSize(ExertUtility.convertToRatio(self.font!.pointSize) * 0.9)
		if self.font.fontName.lowercased().contains("gordita") {
			delay(0, closure: {
				let oldFrame = self.frame
				self.heightAnchor.constraint(equalToConstant: oldFrame.height + 3).isActive = true
			})
		}
		self.layer.cornerRadius = ExertUtility.isIPad ? cornerRadius * 1.5 : cornerRadius
		cornerRadius = ExertUtility.isIPad ? cornerRadius * 1.5 : cornerRadius
			//ExertUtility.isIPad ? font?.withSize(font.pointSize + 3) : font

        //self.font = .systemFont(ofSize: ExertUtility.convertToRatio((self.font.pointSize)))

    } //F.E
} //CLS END

extension BaseUILabel {
	func checkForRange(forText: String) -> NSRange? {
		if let range = self.text?.range(of: forText)?.nsRange {
			return range
		}
		return nil
	}

	func setBoldText(text: String, attributedText: [String]) {

		let myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: self.font!])

		for att in attributedText {
			let nsRange = NSString(string: text).range(of: att, options: String.CompareOptions.caseInsensitive)
			myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SegoeUI-Semibold", size: self.font.pointSize)!, range: nsRange)
		}
		self.attributedText = myMutableString
	}

	func setBoldItalicText(text: String, bold: [String], italic: [String]) {

		let myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: self.font!])

		for att in bold {
			let nsRange = NSString(string: text).range(of: att, options: String.CompareOptions.caseInsensitive)
			myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SegoeUI-Semibold", size: self.font.pointSize)!, range: nsRange)
		}

		for att in italic {
			let nsRange = NSString(string: text).range(of: att, options: String.CompareOptions.caseInsensitive)
			myMutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SegoeUI-SemiboldItalic", size: self.font.pointSize)!, range: nsRange)
		}
		self.attributedText = myMutableString
	}

	func setMultiColor(text: String, coloredText: String, color: String, defaultColor: String) {

		let myMutableString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: self.font!])

		let nsRange = NSString(string: text).range(of: coloredText, options: String.CompareOptions.caseInsensitive)

		myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: defaultColor)!, range: NSMakeRange(0, text.count))
		myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: color)!, range: nsRange)

		self.attributedText = myMutableString
	}
}
