
import UIKit

// MARK: - Extension for UISearchBar to get textField instance
extension UISearchBar {
    var textField: UITextField? {
        get {
            return self.value(forKey: "_searchField") as? UITextField
        }
    }
}

/// BaseUISearchBar is a subclass of UISearchBar and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUISearchBar: UISearchBar {
    
    //MARK: - Properties
    
    /// Background color key from Sync Engine.
    @IBInspectable open var bgColorStyle:UIColor? = nil {
        didSet {
            self.backgroundColor = bgColorStyle
        }
    } //P.E.
    
    @IBInspectable open var fontBgColorStyle:UIColor? = nil {
        didSet {
            if let txtField:UITextField = self.textField {
                txtField.backgroundColor =  fontBgColorStyle
            }
        }
    } //P.E.
    
    @IBInspectable open var tintColorStyle:UIColor? = nil {
        didSet {
            self.tintColor =  tintColorStyle
        }
    } //P.E.
    
    @IBInspectable open var barTintColorStyle:UIColor? = nil {
        didSet {
            self.barTintColor =  barTintColorStyle
        }
    } //P.E.
    
    /// Width of View Border.
    @IBInspectable open var borderWidth:CGFloat = 0 {
        didSet {
            self.addBorderWidth(width: borderWidth)
        }
    } //P.E.
    
    /// Border color key from Sync Engine.
    /// Border Color Config
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.addBordeColor(color: borderColor)
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
    
    /// Inspectable propery for Search bar icon.
    @IBInspectable open var searchBarIcon:UIImage? = nil {
        didSet {
            self.setImage(searchBarIcon, for: UISearchBar.Icon.search, state: UIControl.State());
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter frame: View frame
    override public init(frame: CGRect) {
        super.init(frame: frame);
        
        self.commontInit();
    } //C.E.

    /// Required constructor implemented.
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
    
    //MARK: - Methods
    
    /// Common initazier for setting up items.
    private func commontInit() {
        if let txtField:UITextField = self.textField {
            txtField.font = txtField.font?.withSize(ExertUtility.convertToRatio(txtField.font!.pointSize))
            //txtField.font = .systemFont(ofSize: ExertUtility.convertToRatio((txtField.font!.pointSize)))
        }
    } //F.E

} //CLS END
