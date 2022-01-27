
import UIKit


open class BaseUINavigationItem: UINavigationItem {
    
    //MARK: - Properties
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter title: Title of Navigation Item
    public override init(title: String) {
        super.init(title: title);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    open override func awakeFromNib() {
        super.awakeFromNib();
        //--
    }

} //CLS END
