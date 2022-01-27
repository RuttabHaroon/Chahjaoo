
import UIKit
import AVFoundation

open class ExertUtility: NSObject {
    
	class func messagePopup(message: String, title: String = "Message")-> MessagePopupView? {
		if message.lowercased() == "Unexpected Error".lowercased() {
			EXERT_GLOBAL.gotUnexpectedError = true
		} else {
			EXERT_GLOBAL.gotUnexpectedError = false
		}
		
		let popup = MessagePopupView.loadNib() as? MessagePopupView
		popup?.title = title
		popup?.message = message
		let tupple = ExertUtility.customalertShow(view: popup!)
		popup?.klcPopup = tupple.0
		return popup
	}

	class func selectionPopup(message: String, tag: Int = -1)-> MessagePopupView? {
		let popup = MessagePopupView.loadNib() as? MessagePopupView
		popup?.isMultiSelection = true
		popup?.title = "Confirmation"
		popup?.message = message
		popup?.tag = tag
		let tupple = ExertUtility.customalertShow(view: popup!)
		popup?.klcPopup = tupple.0
		return popup
	}

    class func addTableviewNibs(tableView : UITableView,st:[String])  {
        
        for indentifier in  st {
            let nibOccasion = UINib(nibName: indentifier, bundle: nil);
            tableView.register(nibOccasion, forCellReuseIdentifier:indentifier as String);
        }
    }
	//0: Minute, 1: Second
	class func getTimeInMS(seconds: Int)-> (Int, Int) {
		if seconds == 0 {
			return (0,0)
		} else if seconds == MINUTE {
			return (1,0)
		} else if seconds < MINUTE {
			return (0, seconds)
		} else {
			let minutes = seconds / MINUTE
			let nSeconds = seconds - (minutes * MINUTE)
			return (minutes, nSeconds)
		}
	}
    
    class func isControllerExist<T>(controllername : T.Type ,container:UINavigationController) -> UIViewController?   {

        for controllerobj in container.viewControllers {
            
            if ((controllerobj as? T) != nil) {
                return controllerobj
            }
        }
        return nil
    }
    
    class func addcollectionView(collectionView : UICollectionView,st:[String])  {
        
        for indentifier in  st {
            let nibOccasion = UINib(nibName: indentifier, bundle: nil);
            collectionView.register(nibOccasion, forCellWithReuseIdentifier: indentifier as String)
            
        }
    }
    class func addcollectionViewHeader(collectionView : UICollectionView,st:[String])  {
        for indentifier in  st {
            let nibOccasion = UINib(nibName: indentifier, bundle: nil);
            collectionView.register(nibOccasion, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: indentifier)
        }
    }
    
    class func removeController <T>(controllername : T.Type ,container:UINavigationController) -> [UIViewController] {
        var viewcontrollers = container.viewControllers
        
        for i in 0..<viewcontrollers.count {
            let controllerobj = viewcontrollers[i]
            if ((controllerobj as? T) != nil) {
                viewcontrollers.remove(at: i)
                break
            }
        }
        return viewcontrollers
    }
    
    class func stringSepratedByInt(value : String)-> Int{
        
        let intString = Int(value.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: ""))
        
        return intString!
    }
    class func getCurrentDate () -> String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = oldApiDateFormat
        let  currenttime = Date ()
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    
    class func getDateInfo() -> [String:Any] {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = oldApiDateFormat
        let currentDate = Date()
        let currentDateInString = dateFormatter.string(from: currentDate)
        var data = [String:Any]()
        data["date"] = currentDateInString
        data["days"] = currentDate.numberOfDaysInMonth()
        return data
    }
    
    class func stringToDate(date : String, format : String) -> Date {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)!
    }
    
    class func getCurrentTimeOnly () -> String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = timeformatonly
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let  currenttime = Date ()
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    class func getCurrentDateOnly () -> String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = dateformatonly
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let  currenttime = Date ()
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    class func dateTostring(date:Date) ->String{
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = apiDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let  currenttime = date
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    
    class func dateToStringMMM(date : Date) -> String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = newApiDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let  currenttime = date
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    
    class func dateToStringOld(date:Date) ->String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = oldApiDateFormat
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let  currenttime = date
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    
    class  func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }

    class func numberFormat(price: Int) ->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        
        currencyFormatter.decimalSeparator = ""
        
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en_US")
        
        return currencyFormatter.string(from: NSNumber(value: price)) ?? "0.0"
    }
    
    let currencyFormatter = NumberFormatter()
    
    class func validateTransactionID(val: String)-> Bool {
        let regex = "^[0-9]{4}-[0-9]{1,13}$";
        let testCase = NSPredicate(format:"SELF MATCHES %@", regex)
        let isValid = testCase.evaluate(with: val)
        return isValid;
    }
    
    class func getDateWithFormat(date:Date,format:String) ->String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let  currenttime = date
        let currenttimeinString =  dateFormatter.string(from: currenttime);
        return currenttimeinString
    }
    
    class func getDateFromString(date: String, format: String)->Date {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)!
        
    }

    class func doStringContainsNumber( _string : String) -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        return containsNumber
    }
    
    class func regularEx(text: String?, expression: String)->Bool {
        guard (text != nil) else {
            return false;
        }
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", expression)
        
        return predicate.evaluate(with: text!);
    }
    
    class func uTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateformat
        
        return dateFormatter.string(from: dt!)
    }

    
    public class func customalertShow(view: UIView)-> (KLCPopup, UIView) {
        let klcpopup = KLCPopup.init(contentView: view, showType: .growIn, dismissType: .growOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        klcpopup?.dimmedMaskAlpha =  0.8
        klcpopup?.show()
        return (klcpopup!, view)
    }
    public class func customSearchShow(view: UIView)-> (KLCPopup, UIView) {
        let klcopup = KLCPopup.init(contentView: view, showType: .fadeIn, dismissType: .fadeOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        klcopup?.dimmedMaskAlpha =  0.95
        klcopup?.show()
        return (klcopup!, view)
    }
    func compareDates(date1: Date, date2: Date) -> String {
        if(date1 == date2) {
            return "same"
        } else if(date1 > date2) {
            return "later"
        } else {
            return "sooner"
        }
    }
    
    //MARK: - Properties
    //(UIScreen.main.bounds.width > UIScreen.main.bounds.height) ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    
    @nonobjc static let deviceRatio:CGFloat = UIScreen.main.bounds.height / 736.0;
    @nonobjc static let deviceRatioWN:CGFloat = (UIScreen.main.bounds.height - 64.0) / (736.0 - 64.0); // Ratio with Navigation
    
    //    /// Bool flag for device type.
    @nonobjc static let isIPad:Bool = UIDevice.current.userInterfaceIdiom == .pad;
    /// Converts value to (value * device ratio).
    ///
    /// - Parameters:
    ///   - value: Value
    ///   - sizedForNavi: Bool flag for sizedForNavi
    /// - Returns: Device specific ratio * value
    @objc class func convertToRatio(_ value:CGFloat, sizedForNavi:Bool = false) -> CGFloat {
        
        if (ExertUtility.isIPad) {
            
            if (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
                return ((value/736) * UIScreen.main.bounds.width)
            } else {
				return ((value/736) * UIScreen.main.bounds.height)
            }
            
        }
        if (sizedForNavi) {
            if (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
                return value * (UIScreen.main.bounds.width / 736.0);
            } else {
                return value * ExertUtility.deviceRatio;
            }
        }
        
        if (UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight) {
            return value * (UIScreen.main.bounds.width / 736.0);
        } else {
            return value * ExertUtility.deviceRatio;
        }
        
    } //F.E.
    
    class func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url) //2
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            let time = CMTime(seconds: 0.0, preferredTimescale: 300)
            let times = [NSValue(time: time)]
            
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    DispatchQueue.main.async { //8
                        completion(UIImage(cgImage: image))
                    }
                    
                } else {
                    DispatchQueue.main.async { //8
                        completion(nil) 
                    }
                    
                    
                }
            })
        }
    }
    
    class func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                //print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    
    /// Function to delay a particular action.
    ///
    /// - Parameters:
    ///   - delay: Delay Time in double.
    ///   - closure: Closure to call after delay.
    public class func delay(_ delay:Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }


	/// Function to perform an action on Main thread
	///
	/// - Parameters:
	///   - closure: Closure to call after delay.
	public class func doOnMain(closure:@escaping () -> Void) {
		DispatchQueue.main.async{
			closure()
		}
	}

	//F.E.
    /// Converts value to (value * device ratio) considering navigtion bar fixed height.
    ///
    /// - Parameter value: Value
    /// - Returns: Device specific ratio * value
    @objc class func convertToRatioSizedForNavi(_ value:CGFloat) ->CGFloat {
        return self.convertToRatio(value, sizedForNavi:true); // Explicit true for Sized For Navi
    } //F.E.
    /// Converts CGPoint to (point * device ratio).
    ///
    /// - Parameters:
    ///   - value: CGPoint value
    /// - Returns: Device specific ratio * point
    @objc class func convertPointToRatio(_ value:CGPoint, sizedForIPad:Bool = false) ->CGPoint {
        return CGPoint(x:self.convertToRatio(value.x), y:self.convertToRatio(value.y));
    } //F.E.
    /// Converts CGSize to (size * device ratio).
    ///
    /// - Parameters:
    ///   - value: CGSize value
    /// - Returns: Device specific ratio * size
    @objc class func convertSizeToRatio(_ value:CGSize, sizedForIPad:Bool = false) ->CGSize {
        return CGSize(width:self.convertToRatio(value.width), height:self.convertToRatio(value.height));
    } //F.E.
    /// Validate String for Empty
    ///
    /// - Parameter text: String
    /// - Returns: Bool whether the string is empty or not.
    open class func isEmpty(_ text:String?)->Bool {
        guard (text != nil) else {
            return true;
        }
        
        return (text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "");
    } //F.E.
    /// Validate String for email regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid email or not.
    open class func isValidEmail(_ text:String?)->Bool {
        guard (text != nil) else {
            return false;
        }
        
        let emailRegex:String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return predicate.evaluate(with: text!);
    } //F.E.
    /// Validate String for URL regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid URL or not.
    open class func isValidUrl(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluate(with: text)
    } //F.E.
    /// Validate String for Phone Number regex.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid phone number or not.
    open class func isValidPhoneNo(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        let regexURL: String = "^\\d{3}-\\d{3}-\\d{4}$"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluate(with: text)
    } //F.E.
    /// Validate String for number.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number or not.
    open class func isNumeric(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return Double(text!) != nil;
    } //F.E.
    /// Validate String for alphabetic.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid alphabetic string or not.
    open class func isAlphabetic(_ text:String?) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        for chr in text! {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true;
    } //F.E.
    /// Validate String for minimum character limit.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number of characters.
    open class func isValidForMinChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count >= noOfChar);
    } //F.E.
    /// Validate String for maximum character limit.
    ///
    /// - Parameter text: Sting
    /// - Returns: Bool whether the string is a valid number of characters.
    open class func isValidForMaxChar(_ text:String?, noOfChar:Int) -> Bool {
        guard (text != nil) else {
            return false;
        }
        
        return (text!.utf16.count <= noOfChar);
    } //F.E.
    /// Validate String for a regex.
    ///
    /// - Parameters:
    ///   - text: String
    ///   - regex: Ragex String
    /// - Returns: Bool whether the string is a valid regex string.
    open class func isValidForRegex(_ text:String?, regex:String)->Bool {
        guard (text != nil) else {
            return false;
        }
        
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: text!);
    } //F.E.
}//CLS END
