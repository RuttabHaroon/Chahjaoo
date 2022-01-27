//
//  Utility.swift
//  GIST
//
//  Created by Saami Shoaib on 2/14/17.
//  Copyright © 2017 TechSurge Inc. All rights reserved.
//

import UIKit
import Alamofire


func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
} //F.E.

func getYoutubeVideoDataUrl(apiKey: String, watchIds: [String]) -> String {
	var params = ""
	for watchId in watchIds {
		params += "&id=\(watchId)"
	}
	return "https://www.googleapis.com/youtube/v3/videos?key=\(apiKey)&part=snippet\(params)"
}

func doOnMain(closure:@escaping () -> Void) {
	DispatchQueue.main.async{
		closure()
	}
}

func evaluateHost(urlString: String) -> Bool {
	let policy = SecPolicyCreateBasicX509()
	var optionalTrust: SecTrust?
	var valid = false
	let status = SecTrustCreateWithCertificates([Certificates.certificate] as AnyObject,
												policy,
												&optionalTrust)
	if status == errSecSuccess {
		let trust = optionalTrust!
		for policy in APP_DELEGATE.serverTrustPoliciesManager.policies {
			if policy.value.evaluate(trust, forHost: URL(string: urlString)!.host!) {
				valid = true
			} else {
				return false
			}
		}
		return valid
	}
	return false
}

func sendNotification(notificationName: String, data: [AnyHashable : Any]? = nil) {
	NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: data)
}

func openUrl(url: String) {
	UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
}

class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

class Utility: NSObject {
    
    class func getController (storyboardName:String) ->UIViewController {
        return  UIStoryboard(name:storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardName)
    }
  
    
    //Constants
    class var SECOND:Int  {
        get {return 1;}
    } //P.E.
    
    class var MINUTE:Int {
        get {return (60 * SECOND);}
    } //P.E.
    
    class var HOUR:Int {
        get {return (60 * MINUTE);}
    } //P.E.
    
    class var DAY:Int {
        get {return (24 * HOUR);}
    } //P.E.
    
    class var MONTH:Int {
        get {return (30 * DAY);}
    } //P.E.
    
    class func addTableviewNibs(tableView : UITableView,st:[String])  {
        
        for indentifier in  st {
            let nibOccasion = UINib(nibName: indentifier, bundle: nil);
            tableView.register(nibOccasion, forCellReuseIdentifier:indentifier as String);
        }
    }
    
    class func validateURL(_ urlString:String)-> Bool {
        
        let candidateURL:URL=URL(string: urlString)!
        
        if (((candidateURL.scheme)?.count)! > 0 && (candidateURL.host!).count > 0) {
            return true
        }
        //--
        return false
    } //F.E.
    
    class func calculateLabelSize(_ lbl:UILabel, width:CGFloat)-> CGSize {
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: lbl.text!);
        //--
        let range:NSRange = NSRange(location: 0, length: attString.length);
        //--
        attString.addAttribute(NSAttributedString.Key.font, value: lbl.font ?? UIFont(name: "SegoeUI", size: 14.0)!, range: range);
        
        let rect:CGRect = attString.boundingRect(with: CGSize(width: width, height: 3000), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return CGSize(width: width, height: rect.size.height);
    } //F.E.

    /*
    class func showCustomAlert(_ title:String?, message:String?) {
        let alert = AlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitle: "#ok");
            
        alert.show();
    } //F.E.
    */
    
    class func formateDate(_ date:Date) ->String {
        //Thu, Jan 29, 2015
        return self.formateDate(date, dateFormat: "eee, MMM dd,  YYYY");
    } //F.E.
    
    //IT IS RETURNING DATE IN ISO 8601 WITHOUT COMBINING TIME
    class func formateDateInISO(_ date:Date) ->String {
        //2015-12-15
        return self.formateDate(date, dateFormat: "YYYY-MM-dd");
    } //F.E.
    
    
    //IT IS RETURNING DATE IN ISO 8601 WITH TIME
    class func formateDateInServer(_ string:String) ->Date {
        //2016-12-27 09:21:54
        return self.dateFromString(string, dateFormat: "YYYY-MM-dd HH:mm:ss", timeZone: TimeZone(identifier: "UTC"));
    } //F.E.
    
    class func formateDate(_ date:Date, dateFormat:String) ->String {
        let formatrer:DateFormatter = DateFormatter();
        formatrer.dateFormat = dateFormat;
        
        return formatrer.string(from: date);
    } //F.E.
    
    
    class func dateFromString(_ str:String, dateFormat:String, timeZone:TimeZone? = nil) ->Date {
        let formatrer:DateFormatter = DateFormatter();
        formatrer.dateFormat = dateFormat;
        //--
        if (timeZone != nil) {
            formatrer.timeZone = timeZone!;
        }
        
        return formatrer.date(from: str) ?? Date();
    } //F.E.
    
    class func timeIntervaleFromCurrentDateToDate(_ date:Date) -> TimeInterval {
        return date.timeIntervalSince(Date());
    } //F.E.
    
    //Mark -Unit Conversion
    class func convertKilometerToMiles(_ kilometer:Float) -> Float {
        return ceil((kilometer * 0.621371));
    } //F.E.
    class func convertFeetInchToCentimeter(_ feet:Float, inch:Float) -> Float {
        return ((((feet * 12.0) + inch)) * 2.54);
    } //F.E.
    
    class func convertCentimeterToFeetInch(_ centimeter:Float) -> (feet:Float, inch:Float) {
        
        var inch:Float = (centimeter / 2.54);
        let feet:Float = ceilf(inch / 12.0);
        //--
        inch = inch.truncatingRemainder(dividingBy: 12);
        
        return (feet,inch);
    } //F.E.
    
    class func convertPoundsToKilogram(_ pounds:Float) -> Float {
        return round(pounds / 2.20462) ;
    } //F.E.
    
    class func convertKilogramToPounds(_ kilogram:Float) -> Float {
        return kilogram * 2.20462;
    } //F.E.
    
    //MARK:- Calculate Age
    class func calculateAge (_ birthday: Date) -> NSInteger
    {
        let calendar : Calendar = Calendar.current
        let unitFlags : NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        let dateComponentNow : DateComponents = (calendar as NSCalendar).components(unitFlags, from: Date())
        let dateComponentBirth : DateComponents = (calendar as NSCalendar).components(unitFlags, from: birthday)
        
        if ((dateComponentNow.month! < dateComponentBirth.month!) ||
            ((dateComponentNow.month! == dateComponentBirth.month!) && (dateComponentNow.day! < dateComponentBirth.day!))
            )
        {
            return dateComponentNow.year! - dateComponentBirth.year! - 1
        }
        else {
            return dateComponentNow.year! - dateComponentBirth.year!
        }
    }//F.E.
    
    class func isValidUrl(_ urlString:String) -> Bool {
        
        let regexURL: String = "(http://|https://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexURL)
        return predicate.evaluate(with: urlString)
        
    } //F.E.
    
    class func isNumeric(_ inputString: String) -> Bool {
        return Double(inputString) != nil
    } //F.E.
    
    class func isAlphabets(_ inputString: String) -> Bool {
        for chr in inputString {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    } //F.E.

    class func getXPlistDictionary(_ plistName: String) -> NSMutableDictionary? {
        if let plistPath: String = Bundle.main.path(forResource: plistName, ofType: "plist") {
            return NSMutableDictionary(contentsOfFile: plistPath);
        } else {
            return nil;
        }
    } //F.E.
    
    class func getXPlistValues(_ plistName: String) -> NSMutableArray? {
		if let plistPath: String = Bundle.main.path(forResource: plistName, ofType: "plist") {
            return NSMutableArray(contentsOfFile: plistPath)
        } else {
            return nil;
        }
    } //F.E.
    
   class func applyFilterTo(image:UIImage, filter:String) -> UIImage {
	let ciContext = CIContext(options: nil)
	let imageOrientation = image.imageOrientation
	let originalScale = image.scale
	let imageforCell: UIImage
	let coreImage = CIImage(image: image)
	if let filter = CIFilter(name: filter ) {
		filter.setDefaults()
		filter.setValue(coreImage, forKey: kCIInputImageKey)
		let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage
		let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
		imageforCell = UIImage(cgImage: filteredImageRef!, scale: originalScale, orientation: imageOrientation);
	} else {
		imageforCell = image
	}
        return imageforCell
    }
} //CLS END

extension UIView {
    
    func addTapGesture(tapNumber : Int, target: Any , action : Selector) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

extension UIImage {
    
    func imageByNormalizingOrientation () -> UIImage {
        if self.imageOrientation == .up{
            return self;
        }
        let size = self.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale);
        //[self drawInRec];
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext();
        
        return normalizedImage
    }
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}



extension Array where Element: Hashable {
    var uniqueElements: [Element] {
        var elements: [Element] = []
        for element in self {
            if let _ = elements.firstIndex(of: element) {
            } else {
                elements.append(element)
            }
        }
        return elements
    }
}

// via: [Swift: Safe array indexing: my favorite thing of the new week — Erica Sadun](http://ericasadun.com/2015/06/01/swift-safe-array-indexing-my-favorite-thing-of-the-new-week/)
extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}


extension String{
    var encodeEmoji: String? {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as String?
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as String?
            if valueUniCode != nil {
                return valueUniCode!
            } else {
                return self
            }
        } else {
            return self
        }
    }
}

extension String {
  /*
   Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
   - Parameter length: Desired maximum lengths of a string
   - Parameter trailing: A 'String' that will be appended after the truncation.
    
   - Returns: 'String' object.
  */
  func trunc(length: Int) -> String {
    return (self.count > length) ? self.prefix(length) + "" : self
  }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffleObject() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffledObject() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffleObject()
        return result
    }
}

/*
@implementation UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
    return self;
    
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:(CGRect){{0, 0}, size}];
    UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}

*/


extension Utility {
    class func showHudWithError(_ withDelay : Double = 0.22, errorString: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.showProgressHudWithError(errorMessage: errorString)
            }
        }
    }
    
    class func showHudWithSuccess(_ withDelay : Double = 0.22, sucessString: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.showProgressHudWithSucess(sucessMessage: sucessString)
            }
        }
    }
}
