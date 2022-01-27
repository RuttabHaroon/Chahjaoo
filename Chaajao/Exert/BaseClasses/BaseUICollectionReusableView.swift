

import Foundation
import UIKit
/// BaseUICollectionViewCell is a subclass of UICollectionViewCell and implements BaseView and UIViewControllerPreviewingDelegate. This class should be used for the collection view cells throughout the project.
open class BaseUICollectionReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    
    private var _data:Any?
    
    static var cellIdentifier:String!{
        get {
            return "\(self)"
        }
        
    }
    /// Holds data of the Collection View Cell.
    open var data:Any? {
        get {
            return _data;
        }
        
        set {
            _data = newValue;
        }
    } //P.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.

} //CLS END
