
import UIKit


open class BaseUIViewController: UIViewController {
    
    
    //   @IBOutlet weak var noInternetView: NoInternetView!
    /// Inspectable property for navigation back button - Default back button image is 'NavBackButton'
    @IBInspectable open var backBtnImageName:String = EXERT_GLOBAL.navigationBackButtonImgName;
    
    @IBInspectable open var totalRightButtons: Int = 0
    @IBInspectable open var titleorImageList: String?
    @IBInspectable open var rightButtonTintColor: String?
    @IBInspectable open var typeList: String?
    
    static var controllerName:String!{
        get {
            return "\(self)"
        }
    }
    
    
    
    
    @IBInspectable open var isonlyText:Bool = false
    @IBInspectable open var rightButtonImage:String?
    @IBInspectable open var rightButtonText:String?
    
    private var _hasBackButton:Bool = true;
    open var hasNavigationBar:Bool = true{
        didSet {
            self.navigationController?.setNavigationBarHidden(!hasNavigationBar, animated: false)
        }
    }
    
    /// Flag for back button visibility.
    open var hasBackButton:Bool {
        get {
            return _hasBackButton;
        }
        
        set {
            _hasBackButton = newValue;
        }
    } //P.E.
    
    private var _hasForcedBackButton = false;
    
    /// Flag for back button visibility by force.
    open var hasForcedBackButton:Bool {
        get {
            return _hasForcedBackButton;
        }
        
        set {
            _hasForcedBackButton = newValue;
            //--
            if (_hasForcedBackButton) {
                _hasBackButton = true;
            }
        }
    } //P.E.
    
    private var _lastSyncedDate:String?
    
    private var _titleKey:String?;
    
    /// Overriden title property to set title
    override open var title: String? {
        get {
            return super.title;
        }
        set {
            super.title = newValue;
        }
    } //P.E.
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButton:Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        _hasBackButton = backButton;
    } //F.E.
    /// Overridden constructor to setup/ initialize components.
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, backButtonForced:Bool){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        _hasBackButton = backButtonForced;
        _hasForcedBackButton = backButtonForced;
    } //F.E.
    /// Required constructor implemented.
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    } //F.E.
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func viewDidLoad() {
        super.viewDidLoad();
        NotificationCenter.default.addObserver(self, selector: #selector(resetBackBtn), name: Notification.Name("resetBackBtn"), object: nil)
    } //F.E.
    
    @objc func resetBackBtn(notification: NSNotification) {
        self.setupBackBtn();
    }
    /// Overridden method to setup/ initialize components.
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //--
        self.setupBackBtn();
        
        
    }//F.E.
    
    //    func internetConnectionFailed (httpRequest:HTTPRequest, isInternetAvailable:Bool) {
    //
    //    }
    //MARK: - Methods
    
    ///Setting up custom back button.
    public func setupBackBtn() {
        if (_hasBackButton) {
            if (self.navigationItem.leftBarButtonItem == nil && _hasForcedBackButton || (self.navigationController != nil)) {
                self.navigationItem.hidesBackButton = true;
                //--
                
                let rbtn2 = UIButton(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
                rbtn2.setImage(UIImage(named: self.backBtnImageName), for: .normal)
                rbtn2.addTarget(self, action: #selector(backButtonTapped) , for: .touchUpInside)
                rbtn2.addTarget(self, action: #selector(handleBackButtonTapped) , for: .touchUpInside)
                let butt = UIBarButtonItem(customView: rbtn2)
                
                self.navigationItem.leftBarButtonItem = butt
            }
        } else {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
    } //F.E.
    
    ///Navigation back button tap handler.
    @objc open func backButtonTapped() {
        DispatchQueue.main.async(execute: {
            self.view.endEditing(true);
			APP_DELEGATE.hideProgressHud()
			HTTPServiceManager.cancelAllRequests()
            _ = self.navigationController?.popViewController(animated: true)
        })
    } //F.E.
    
    @objc open func handleBackButtonTapped() {
        DispatchQueue.main.async(execute: {
            self.view.endEditing(true);
        })
    }
    
    @objc func rightButtonTapped(sender: UIButton) {
        self.view.endEditing(true);
    } //F.E.
    
    @objc open func rightButtonTapped2() {
        self.view.endEditing(true);
    } //F.E.
    
    @objc open func rightButtonTapped3() {
        self.view.endEditing(true);
        
    } //F.E.
    
    func internetConnectionFailed (httpRequest: HTTPRequest?, isInternetAvailable:Bool) {
        
    }
    
    
} //CLS END


extension UIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        
    }
}
