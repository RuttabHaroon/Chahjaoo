//
//   UserPreferences.swift


import UIKit
import ObjectMapper

class UserPreferences: NSObject {
    
    private static var sharedUserPreferences: UserPreferences = {
         let networkManager = UserPreferences()

         // Configuration
         // ...

         return networkManager
     }()
    
    // MARK: - Accessors

   class func shared() -> UserPreferences {
       return sharedUserPreferences
   }
    
    
    //static let sharedUserPreferences = UserPreferences()
    
    //PRIVATE init so that singleton class should not be reinitialized from anyother class
    private override init() {
        
    }
    class func clearAll(sessionExpired: Bool) {
        if sessionExpired {
            _ = ExertUtility.messagePopup(message: "Session has expired.\nPlease login again.")
        }
//		USER_DEFAULTS.removeObject(forKey: "loginObject")
    }

    var hasLaunchedBefore: Bool {
        get {
            return USER_DEFAULTS.bool(forKey: "hasLaunchedBefore")
        }
        set {
            USER_DEFAULTS.setValue(newValue, forKey: "hasLaunchedBefore")
            USER_DEFAULTS.synchronize()
        }
    }
    var isLoggedIn: Bool {
		get {
			return USER_DEFAULTS.bool(forKey: "isLoggedIn")
		}
		set {
			USER_DEFAULTS.setValue(newValue, forKey: "isLoggedIn")
			USER_DEFAULTS.synchronize()
		}
	}
    var loggedInToken : Token {
        get {
            return decodeTokenObjc()!
        }
        set {
            encodeTokenObjc(t: newValue)
        
        }
    }
    
    var userPickedTestType : Int {
        get {
            return USER_DEFAULTS.integer(forKey: "userPickedTestType")
        }
        set {
            USER_DEFAULTS.setValue(newValue, forKey: "userPickedTestType")
            USER_DEFAULTS.synchronize()
        
        }
    }
    
    private  func encodeTokenObjc(t : Token){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(t)
            USER_DEFAULTS.setValue(data, forKey: "loggedInToken")
            USER_DEFAULTS.synchronize()
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    private  func decodeTokenObjc() -> Token? {
        do {
            if let d =  USER_DEFAULTS.data(forKey: "loggedInToken") {
                let decoder = JSONDecoder()
                let token = try decoder.decode(Token.self, from: d)
                return token
            }
            return nil
         } catch {
             print("Unable to Decode Note (\(error))")
             return nil
         }
    }
    
    // P.E.
} //CLS END


extension UserPreferences {
    var userModelData : User? {
        get {
            return decodeUserObjc() ?? nil
        }
        set {
            encodeUserObjc(t: newValue!)
        
        }
    }
    
    private  func encodeUserObjc(t : User){
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(t)
            USER_DEFAULTS.setValue(data, forKey: "userModelData")
            USER_DEFAULTS.synchronize()
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    private  func decodeUserObjc() -> User? {
        do {
            if let d =  USER_DEFAULTS.data(forKey: "userModelData") {
                let decoder = JSONDecoder()
                let uData = try decoder.decode(User.self, from: d)
                return uData
            }
            return nil
         } catch {
             print("Unable to Decode Note (\(error))")
             return nil
         }
    }
}


extension UserPreferences {
    func clearAllOnLogout() {
        UserPreferences.shared().isLoggedIn = false
        USER_DEFAULTS.removeObject(forKey: "userModelData")
        USER_DEFAULTS.removeObject(forKey: "loggedInToken")
    }
}
