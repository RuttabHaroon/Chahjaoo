
import UIKit



open class BaseLayoutConstraint: NSLayoutConstraint {
    
    //MARK: - Properties
    /// Flag for whether to resize the values considering UINavigationbar fixed height(64).
    @IBInspectable open var sizeForNavi:Bool = false
    @IBInspectable public var sizeForIPad:Bool = false;
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        if constant ==  337 {
        
        }
        self.constant = ExertUtility.convertToRatio(constant)
        
          //self.constant = ExertUtility.convertToRatio(constant, sizedForIPad:false, sizedForNavi:false);
        //self.constant = ExertUtility.convertToRatio(constant,sizedForNavi:sizeForNavi);
    } //F.E.
} //CLS END
