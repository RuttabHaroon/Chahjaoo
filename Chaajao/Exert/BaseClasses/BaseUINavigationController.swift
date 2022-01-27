
import UIKit

/// BaseUINavigationController is a subclass of UINavigationController.
open class BaseUINavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {


//	public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//		if let coordinator = navigationController.topViewController?.transitionCoordinator {
//			coordinator.notifyWhenInteractionChanges({ (context) in
//				if context.isCancelled {
//					self.popViewController(animated: true)
//				}
//			})}
//	}
    //MARK: - Properties

    /// Navigation background Color key from SyncEngine.
    @IBInspectable open var bgColor:UIColor? {
        didSet {
            self.navigationBar.barTintColor = bgColor
            
            if self.navigationBar.tintColor.cgColor.alpha == 0 {
            //Fixing black line issue when the navigation is transparent
                self.navigationBar.setBackgroundImage(UIImage(), for: .default);
                self.navigationBar.shadowImage = UIImage();
            }
        }
    }
    
    /// Navigation tint Color key from SyncEngine.
    @IBInspectable open var tintColor:UIColor? = nil {
        didSet {
            self.navigationBar.tintColor = tintColor
        }
    }
    
     /// Font name key from Sync Engine.
    @IBInspectable open var fontName:String = EXERT_GLOBAL.fontName {
        didSet {
            let attrDict = [NSAttributedString.Key.font: UIFont(name: EXERT_GLOBAL.fontName, size: EXERT_GLOBAL.fontSize)!]
           self.navigationBar.titleTextAttributes = attrDict;
        //    self.navigationBar.titleTextAttributes =
        }
    }
    
    /// Font size/style key from Sync Engine.
    @IBInspectable open var fontSize:CGFloat = EXERT_GLOBAL.fontSize {
        didSet {
            let attrDict = [NSAttributedString.Key.font: UIFont(name: EXERT_GLOBAL.fontName, size: EXERT_GLOBAL.fontSize)!]
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }

    /// Font color key from Sync Engine.
    @IBInspectable open var fontColor:UIColor? = nil {
        didSet {
            var attrDict:[NSAttributedString.Key : Any] = self.navigationBar.titleTextAttributes ?? [NSAttributedString.Key : Any]();
            attrDict[NSAttributedString.Key.foregroundColor] = fontColor
            self.navigationBar.titleTextAttributes = attrDict;
        }
    }
    
     /// Flag for Navigation bar Shadow - default value is true
    @IBInspectable open var hasShadow:Bool = true {
        didSet {
            if (hasShadow == false) {
                self.navigationBar.shadowImage = UIImage();
            }
        }
    }
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter rootViewController: Root View Controller of Navigation
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
		self.delegate = self
    } //F.E.
    
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib Name
    ///   - nibBundleOrNil: Nib Bundle Name
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad();
		//setNeedsStatusBarAppearanceUpdate()
        interactivePopGestureRecognizer?.delegate = self

        //--
    } //F.E.


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		setNeedsStatusBarAppearanceUpdate()
	}

	open override var preferredStatusBarStyle: UIStatusBarStyle {
		if #available(iOS 13.0, *) {
			return .darkContent
		} else {
			return .lightContent
		}
	}

    /// Overridden method to receive memory warning.
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
//MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if navigationController?.topViewController as? TestMainVC != nil {
			return false
		}
         return viewControllers.count > 1
     }

    
    //F.E.
//    override open func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        fixNavigationItemsMargin(0)
//    }
//    
//    override open func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        fixNavigationItemsMargin(0)
//    }
    //MARK: - Methods
} //F.E.
