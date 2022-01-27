
import UIKit
import Alamofire
import SystemConfiguration


var REACHABILITY_HELPER:ReachabilityHelper {
    get {
        return ReachabilityHelper.sharedInstance;
    }
} //P.E.

class ReachabilityHelper: NSObject {
    
    
    //private lazy var _window: UIWindow =  (UIApplication.shared.delegate?.window!)!
    
    static var sharedInstance: ReachabilityHelper = ReachabilityHelper();
    
    fileprivate var _reachability:NetworkReachabilityManager?;
    
    fileprivate var _internetConnected:Bool = false;
    fileprivate var internetConnected:Bool {
        get {
            return _internetConnected;
        }
        
        set {
            _internetConnected = newValue;
            self.internetConnectionLabelHidden = _internetConnected;
        }
    } //P.E.
    
    //Public Method
    var isInternetConnected:Bool {
        get {
			setupReachability()
            if (self.internetConnectionLabelHidden != _internetConnected) {
                self.internetConnectionLabelHidden = _internetConnected;
            } else if (_internetConnected == false) {
//                self._internetConnectionButton.shake();
            }
            //--
            return _internetConnected;
        }
    } //P.E.
    fileprivate var _internetConnectionButton:BaseUIButton!;
    fileprivate var internetConnectionButton:BaseUIButton {
        get {
            
            if (_internetConnectionButton == nil)
            {
//                let btnSize:CGSize = CGSize(width: ExertUtility.convertToRatio(220), height: ExertUtility.convertToRatio(40));
                //--
                _internetConnectionButton = BaseUIButton();
               // _internetConnectionButton.frame = CGRect(x: (_window.frame.width - btnSize.width) / 2.0, y: -(btnSize.height), width: btnSize.width, height: btnSize.height);
                _internetConnectionButton.setTitle("No Internet Connection", for: UIControl.State.normal);
                _internetConnectionButton.setTitleColor(UIColor.white, for: UIControl.State.normal);
                _internetConnectionButton.backgroundColor = UIColor.orange.withAlphaComponent(0.7);
                _internetConnectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                
                //Adding Target
                _internetConnectionButton.addTarget(self, action: #selector(ReachabilityHelper.internetConnectionLabelTapHandler(_:)) , for: UIControl.Event.touchUpInside)
//
                _internetConnectionButton.addRoundedCorners(5);
                _internetConnectionButton.addBorder(UIColor.white.withAlphaComponent(0.9), width: 2);
               // _window.addSubview(_internetConnectionButton);
                _internetConnectionButton.isHidden = true
            }
            
            //--
            return _internetConnectionButton;
        }
    } //P.E.
    
    fileprivate var _internetConnectionLabelHidden:Bool!;
    fileprivate var internetConnectionLabelHidden:Bool {
        
        set {
            if (_internetConnectionLabelHidden != newValue)
            {
                _internetConnectionLabelHidden = newValue;
                var newFrame = self.internetConnectionButton.frame;
                if (_internetConnectionLabelHidden == true)
                {newFrame.origin.y = -newFrame.height;}
                else
                {
                    newFrame.origin.y = 0;
                   // _window.bringSubviewToFront(self.internetConnectionButton);
                }
                UIView.animate(withDuration: 0.35, animations: { () -> Void in
                    //self.internetConnectionLbl.frame = newFrame;
                     self.internetConnectionButton.frame = newFrame;
                });
            }
        }
        get {
            return (_internetConnectionLabelHidden == nil) ?true:_internetConnectionLabelHidden;
        }
    } //P.E.
    //MARK: - setupReachability
    func setupReachability() {
        _reachability = NetworkReachabilityManager();
        _reachability!.listener = self.reachabilityUpdate;
        _reachability!.startListening();
    } //F.E.
    
    
    func reachabilityUpdate(_ status:NetworkReachabilityManager.NetworkReachabilityStatus) {
        //print("status : \(status)")
        
        switch status {
        case .notReachable:
        //Show error state
            self.internetConnected = false;
            break;
        case .reachable(_), .unknown:
            //Hide error state
            self.internetConnected = true;
            break;
        }
    } //F.E.
    
    @objc func internetConnectionLabelTapHandler(_ btn:AnyObject) {
        self.internetConnectionLabelHidden = true;
    } //F.E.
    
    private func connectionType(_ status:NetworkReachabilityManager.NetworkReachabilityStatus) -> String{
        
        switch status {
        case .notReachable:
            return "no internet"
        case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
            return "Wifi"
        case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
            return "Wan"
        case .unknown:
            return "unknown"
        }
    }
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    public func connectionType() -> String{
        return self.connectionType(_reachability!.networkReachabilityStatus);
    }
} //CLS END
