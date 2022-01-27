
import UIKit

/// BaseUICollectionViewCell is a subclass of UICollectionViewCell and implements BaseView and UIViewControllerPreviewingDelegate. This class should be used for the collection view cells throughout the project.
open class BaseUICollectionViewCell: UICollectionViewCell, UIViewControllerPreviewingDelegate {
    
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
    
    /// This method should be called in cellForRowAt:indexPath. it also must be overriden in all sub classes of BaseUICollectionViewCell to update the collection view cell's content.
    ///
    /// - Parameter data: Cell Data
    open func updateData(_ data:Any?) {
        _data = data;
        //--
//        self.updateSyncedData();
    } //F.E.
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //DOING NOTHING FOR NOW
    } //F.E.
    
    //MARK: - UIViewControllerPreviewingDelegate protocol methods
    
    /// Protocol method for viewControllerForLocation (CGPoint)
    ///
    /// - Parameters:
    ///   - previewingContext: UIViewControllerPreviewing
    ///   - location: Location for view controller
    /// - Returns: returns view controller for location - nil by default
    open func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        return nil;
    } //F.E.
    
    
    /// Protocol method for viewControllerToCommit
    ///
    /// - Parameters:
    ///   - previewingContext: UIViewControllerPreviewing
    ///   - viewControllerToCommit: ViewController to commit
    open func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    } //F.E.
    
} //CLS END
