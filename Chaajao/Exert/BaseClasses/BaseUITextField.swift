
import UIKit


open class BaseUITextField: UITextField, UITextFieldDelegate {
   
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

    /// Placeholder Text Font color key from SyncEngine.
    @IBInspectable open var placeholderColor:UIColor? = nil {
        didSet {
            if let plcHolder:String = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string:plcHolder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor!]);
            }
        }
    } //P.E.
    
    
    /// Text Vertical Padding - Default Value is Zero
    @IBInspectable open var verticalPadding:CGFloat=0
    
    /// Text Horizontal Padding - Default Value is Zero
    @IBInspectable open var horizontalPadding:CGFloat=0
    
    private var _maxCharLimit: Int = 50;
    
    /// Max Character Count Limit for the text field.
    @IBInspectable open var maxCharLimit: Int {
        get {
            return _maxCharLimit;
        }
        
        set {
            if (_maxCharLimit != newValue)
            {_maxCharLimit = newValue;}
        }
    } //P.E.
    
    
    private weak var _delegate:UITextFieldDelegate?;
    
    ///Maintainig Own delegate.
    open override weak var delegate: UITextFieldDelegate? {
        get {
            return _delegate;
        }
        
        set {
            _delegate = newValue;
        }
    } //P.E.
    
  
    
    //MARK: - Constructors
    
    /// Overridden method to setup/ initialize components.
    ///
    /// - Parameter frame: View Frame
    override public init(frame: CGRect) {
        super.init(frame: frame);
        //--
//        self.commonInit();
    } //C.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //C.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
        //--
        self.commonInit();
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
        //--
        if rounded {
            self.addRoundedCorners();
        }
    } //F.E.
	@IBInspectable var isPasteEnabled: Bool = true

	@IBInspectable var isSelectEnabled: Bool = true

	@IBInspectable var isSelectAllEnabled: Bool = true

	@IBInspectable var isCopyEnabled: Bool = true

	@IBInspectable var isCutEnabled: Bool = true

	@IBInspectable var isDeleteEnabled: Bool = true

	open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		switch action {
			case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
				 #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
				 #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
				 #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
				 #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
				 #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
				return false
			default:
				//return true : this is not correct
				return super.canPerformAction(action, withSender: sender)
		}
	}
    
    /// Overridden method to handle text paddings
    ///
    /// - Parameter bounds: Text Bounds
    /// - Returns: Calculated bounds with paddings.
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        //??super.textRectForBounds(bounds)
        
        let x:CGFloat = bounds.origin.x + ExertUtility.convertToRatio(horizontalPadding)
        let y:CGFloat = bounds.origin.y + ExertUtility.convertToRatio(verticalPadding)
        let widht:CGFloat = bounds.size.width - (ExertUtility.convertToRatio(horizontalPadding) * 2)
        let height:CGFloat = bounds.size.height - (ExertUtility.convertToRatio(verticalPadding) * 2)
        
        return CGRect(x: x,y: y,width: widht,height: height)
    } //F.E.
    
    /// Overridden method to handle text paddings when editing.
    ///
    /// - Parameter bounds: Text Bounds
    /// - Returns: Calculated bounds with paddings.
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return self.textRect(forBounds: bounds)
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        super.delegate = self;
//        self.font = font?.withSize(ExertUtility.convertToRatio(self.font!.pointSize))
        //self.font = .systemFont(ofSize: ExertUtility.convertToRatio((self.font!.pointSize)))
    } //F.E.
    
    //Mark: - UITextField Delegate Methods
    
    /// Protocol method of textFieldShouldBeginEditing.
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should begin edititng
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldBeginEditing?(textField) ?? true;
    } //F.E.
    
    /// Protocol method of textFieldDidBeginEditing.
    ///
    /// - Parameter textField: Text Field
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField);
    } //F.E.
    
    
    /// Protocol method of textFieldShouldEndEditing. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should end edititng
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldEndEditing?(textField) ?? true;
    } //F.E.
    
    /// Protocol method of textFieldDidEndEditing
    ///
    /// - Parameter textField: Text Field
    open func textFieldDidEndEditing(_ textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField);
    } //F.E.
    
    
    /// Protocol method of shouldChangeCharactersIn for limiting the character limit. - Default value is true
    ///
    /// - Parameters:
    ///   - textField: Text Field
    ///   - range: Change Characters Range
    ///   - string: Replacement String
    /// - Returns: Bool flag for should change characters in range
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rtn = _delegate?.textField?(textField, shouldChangeCharactersIn:range, replacementString:string) ?? true;
        
        //IF CHARACTERS-LIMIT <= ZERO, MEANS NO RESTRICTIONS ARE APPLIED
        if (self.maxCharLimit <= 0) {
            return rtn;
        }
        
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return (newLength <= self.maxCharLimit) && rtn // Bool
    } //F.E.
    
    /// Protocol method of textFieldShouldClear. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for should clear text field
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldClear?(textField) ?? true;
    } //F.E.
    
    
    /// Protocol method of textFieldShouldReturn. - Default value is true
    ///
    /// - Parameter textField: Text Field
    /// - Returns: Bool flag for text field should return.
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return _delegate?.textFieldShouldReturn?(textField) ?? true;
    } //F.E.
    
} //CLS END
