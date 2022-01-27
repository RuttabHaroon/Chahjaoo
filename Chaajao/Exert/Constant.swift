
import UIKit
import SecureDefaults

//MARK:- Enums
enum TestType : Int {
    case classTest = 0
    case grandTest = 1
    case subjectMockTest = 2
    case chapterTest = 3
    case topicTest = 4
}

//enum TestQuestionType : Int, CaseIterable {
//    case MCQS = 1
//    case content = 2
//    case reading = 3
//    case MCQSMultiSelection = 4
//    case none = -1
//}


enum ComingFrom {
    case signup
    case forgotPassword
}


enum PaymentMethod: String {
	case JazzCash = "JazzCash";
	case EasyPaisa = "EasyPaisa";
	case Card = "Card";
	case IBFT = "IBFT";
}

enum cellType: Int {
	case profileInputCell
	case notificationCell
	case courseCollectionCell
	case courseListCell
	case programListCell
	case chaptersCollectionCell
	case testListCell
	case answerCell
	case bookmarkListCell
	case analyticsSubjectCell
	case newsCell
	case singleBtnFooterCell
}

enum result: String {
	case best = "CHAA GAYE BHAI, CHAA GAYE!";
	case ok = "THORA AUR ACHA KAR SAKTAY THAY!";
	case worst = "MAZA NAHI AYA!";
}

enum Answer: String {
	case correct = "Answer.Correct"; case wrong = "Answer.Wrong";
}

public enum GradientOrientation {
	case vertical
	case horizontal
}

enum otpStates: Int {
	case sent
	case verified
	case error
	case loading
}


enum APIErrors : String {
    case generic = "Something went wrong"
}

//MARK: API URLs, Constants & Methods

//Base URL
let baseURL = "https://csp-qa.cdcaccess.com.pk:8443/"
// Pinning Constants
let isPinningEnabled = false
let CERT_FILENAME = "csp_qa"

//MARK: Date/Time Format Constants
let dateformat = "MM-dd-yyyy hh:mm a"
let apiDateFormat = "MM/dd/yyyy"
let oldApiDateFormat = "dd/MM/yyyy"
let newApiDateFormat = "dd-MMM-yyyy"
let challengedateformat = "yyyy-MM-dd HH:mm"
let displaydateformat = "dd MMM, yyyy - hh:mma"
let timeformatonly = "hh:mm:ss"
let dateformatonly = "yyyy-MM-dd"
let appSharingText = "Personalized learning on the Chaajao's app helped me master my fundamentals. Download now for free and learn from the best teachers!\n\nhttps://apps.apple.com/in/app/ibagrads-chaajao/id1015010914"
let SECOND = 1
let MINUTE = 60
let HOUR = 3600

//Changes
let salutation = "Hi"


//MARK: UI + App Constants

let WINDOW_FRAME                = UIScreen.main.bounds
let SCREEN_SIZE                 = UIScreen.main.bounds.size
let WINDOW_WIDTH                = UIScreen.main.bounds.size.width
let WINDOW_HIEGHT               = UIScreen.main.bounds.size.height

let APP_DELEGATE                = UIApplication.shared.delegate as! AppDelegate
let UIWINDOW                    = UIApplication.shared.delegate!.window!

let USER_DEFAULTS               = SecureDefaults.shared
let defaultBtnFontName = ""
//MARK:- Structs

//Represents a SecCertificate Object that can be used for SSL Pinning.
struct Certificates {
	static let certificate: SecCertificate = Certificates.certificate(filename: CERT_FILENAME)

	private static func certificate(filename: String) -> SecCertificate {

		let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
		let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
		let certificate = SecCertificateCreateWithData(nil, data as CFData)!

		return certificate
	}
}
struct CoursePickerModel {
	var instituteName: String
	var iconName: String
	var isSelected: Bool
    var programs: [Program]?
}

struct SubjectPickerModel {
	var name: String
	var iconName: String
	var isSelected: Bool
}

struct AnalyticsSubjectPickerModel {
	var name: String
	var iconName: String
	var isSelected: Bool
}

struct PackageModel {
	var name: String
	var price: String
	var features: [String]
	var selected: Bool = false
}

struct PaymentModel {
	var name: String
	var iconName: String
}


struct QuestionModel {
    var questionID : Int
	var text: String
	var img: String?
	var category: String
	var answers: [AnswerModel]
	var isBookmarked: Bool
    var timeTaken: Int
    var questionType: Int
    var questionAnswerTyped: String
    var questionDiffcultyLevel: String
}

struct AnswerModel {
    var answerID : Int
	var text: String
	var reason: String
	var imageLink: String
	var isCorrect: Bool
	var shouldExpand:Bool
	var isSelected: Bool
    var questionID: Int
    var questionDiffcultyLevel: String
}

let purchasedCourses = ["Chaajao Advanced", "Chaajao Ultimate"]
let degrees = ["Matric", "Intermediate", "O-Levels", "A-Levels", "Graduation"]
let genders = ["Male", "Female", "Transgender"]
let countries = ["Afghanistan", "India", "Pakistan", "UAE"]
let cities: [String: [String]] = ["Pakistan": ["Islamabad", "Karachi", "Lahore"], "India" : ["Bengaluru", "Chennai", "Mumbai"], "UAE" : ["Abu Dhabi", "Dubai", "Sharjah"], "Afghanistan" : ["Herat", "Kabul", "Kandahar"]]


//MARK: Youtube Data API Key
let YT_API_KEY = "AIzaSyByNvQSBZYocIwnyDzePhefje3bPtRQetM"

//Represents regexes for validations
struct validations {
	static let cnicRegex = "[0-9]{5}(-)?[0-9]{7}(-)?[0-9]{1}"
	static let passportRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,16}$"
    static let ibanRegex = "PK[0-9]{2}[A-Z]{4}[0-9]{16}"
	static let password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*[0-9]{2}).{8,}$"
	static let mobileRegex = "^03[0-4][0-9][0-9]{7}$"
    static let emailRegex = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
                "\\@" +
                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                "(" +
                    "\\." +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                ")+"
}

//MARK: Validations
extension String {
    func isValidEmail() -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", validations.emailRegex)
        return emailPred.evaluate(with: self)
    }
    
    func isValidMobileNumber() -> Bool {
        let mobilePred = NSPredicate(format: "SELF MATCHES %@", validations.mobileRegex)
        return mobilePred.evaluate(with: self)
    }
    
    func isValidCnic() -> Bool {
        let cnicPred = NSPredicate(format: "SELF MATCHES %@", validations.cnicRegex)
        return cnicPred.evaluate(with: self)
    }
    
    func isValidPassport() -> Bool {
        let passportPred = NSPredicate(format: "SELF MATCHES %@", validations.passportRegex)
        return passportPred.evaluate(with: self)
    }
    
    func isValidIban() -> Bool {
        let ibanPred = NSPredicate(format: "SELF MATCHES %@", validations.ibanRegex)
        return ibanPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", validations.password)
        return passwordPred.evaluate(with: self)
    }
}

//MARK: API URL
extension String {
	//Get a complete URL with baseURL
	func apiUrl() -> URL? {
		return URL(string: "\(baseURL)\(self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
	}
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
