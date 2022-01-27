
import UIKit

//Internal Property
let EXERT_GLOBAL = EXERTGlobal.sharedInstance;

/// EXERTGlobal is a singleton instance class to hold default properties for the framework.
public class EXERTGlobal: NSObject {
    
    static let sharedInstance = EXERTGlobal()

    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    fileprivate override init() {} //C.E.

	public var isLaunchOption = false
    public var fontName:String = "Gordita-Regular"
	public var GORDITA_BOLD:String = "Gordita-Bold"
	public var SIZE_BOLD:CGFloat = 20
	public var fontSize:CGFloat = ExertUtility.isIPad ? 20 : 15
    public var navigationBackButtonImgName:String = "back-icon"
    public var gotUnexpectedError = false
    public var sizeForIPad:Bool = true
    public var sizeForNavi:Bool = false
	public var lastStatusBarHeight: CGFloat = 0
	public var tabBarHeight: CGFloat = 0
	public var statusBarHeight : CGFloat {
		get {
			var height: CGFloat = 0
			if #available(iOS 13, *) {
				height = (APP_DELEGATE.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
			} else {
				let statusBarSize = UIApplication.shared.statusBarFrame.size
				height = Swift.min(statusBarSize.width, statusBarSize.height)
			}
			if height > 44 {
				height = 44
			}
			if height != 0 {
				lastStatusBarHeight = height
				return height
			} else if lastStatusBarHeight != 0 {
				return lastStatusBarHeight
			} else {
				return UIDevice.current.hasNotch ? 44 : 20
			}
		}
	}
    public var seperatorWidth:CGFloat = 0.5;
    public var isLandscape:Bool = false
	public var controllerBackgroundColor = UIColor(named: "controllerBackground")!
	public var activeTabTint = UIColor(named: "activeMenuItemTint")!
	public var inactiveTabTint = UIColor(named: "inactiveMenuItemTint")!
	public var readNotification = UIColor(named: "read")!
} //CLS END




