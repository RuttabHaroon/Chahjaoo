
import Foundation
import UIKit
open class BaseUITabBarItem: UITabBarItem {
    //MARK: - Properties
    
    /// Font name key from Sync Engine.
    @IBInspectable open var isTextEnable:Bool = true {
        didSet {
            if !isTextEnable {
                self.title = nil
                self.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commontInit();
    } //F.E.
    
    /// Common initazier for setting up items.
    private func commontInit() {
//        self.font = font?.withSize(ExertUtility.convertToRatio(self.font!.pointSize))
    
    }
}
