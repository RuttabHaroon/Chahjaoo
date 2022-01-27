
import UIKit

open class BaseUITextView: UITextView , PlaceholderDesignable {
    
    //MARK: - Properties
    static var viewName:String!{
        get {
            return "\(self)"
        }
    }

	/// Number of Lines Config
	@IBInspectable var numberOfLines: Int = 1 {
		didSet {
			self.textContainer.maximumNumberOfLines = numberOfLines
			self.textContainer.lineBreakMode = .byTruncatingTail
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
    
    // MARK: - PlaceholderDesignable
    @IBInspectable open var placeholderLabelText: String? {
        didSet {
            placeholderLabel.text = placeholderLabelText
        }
    }
    
    @IBInspectable open var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    /// Text Vertical Padding - Default Value is Zero
    @IBInspectable open var verticalPadding:CGFloat=0
    
    /// Text Horizontal Padding - Default Value is Zero
    @IBInspectable open var horizontalPadding:CGFloat=0
    // MARK: Override properties
    override open var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    open override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            update(placeholderLabel, using: &placeholderLabelConstraints)
        }
        
    }
    // MARK: Private properties
    fileprivate let placeholderLabel: UILabel = UILabel()
    fileprivate var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    // MARK: - Lifecycle
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureInspectableProperties()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configureInspectableProperties()
        self.commonInit()
        self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: ExertUtility.convertToRatio(self.horizontalPadding), bottom: self.contentInset.bottom, right: ExertUtility.convertToRatio(self.verticalPadding))
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name:  UITextView.textDidChangeNotification, object: nil)
    }
    
    // MARK: - Private
    private func configureInspectableProperties() {
        configure(placeholderLabel: placeholderLabel, placeholderLabelConstraints: &placeholderLabelConstraints)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name:  UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc
    private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func configureAfterLayoutSubviews() {
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    //MARK: - Constructors
    
    /// Overridden method to setup/ initialize components.
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer);
        //--
        self.commonInit()
    } //C.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        //self.commonInit()
    } //C.E.
    
    //MARK: - Methods
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
//        self.font = font?.withSize(ExertUtility.convertToRatio(self.font!.pointSize))
		self.layer.cornerRadius = ExertUtility.isIPad ? cornerRadius * 1.5 : cornerRadius
		cornerRadius = ExertUtility.isIPad ? cornerRadius * 1.5 : cornerRadius
        self.placeholderLabel.font = self.font
    }
} //CLS END
