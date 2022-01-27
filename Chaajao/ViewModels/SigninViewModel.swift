//
//  SigninViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 11/12/2021.
//

import Foundation
import Alamofire

class signinViewModel {
    
    var email = ""
    var password = ""
    
    func login() {
        
        if(isValid()==false) {
            return
        }
        
        let param = [
            "email": "vilod46243@wusehe.com", //email,
             "password": "Abc123!" ,//password,
             "deviceToken": "string",
             "appVersion": "string"
        ]
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .signIn),
                                   parameters: param,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
    }
    
    private func isValid() ->Bool {
        var status = true
        let validationResponse = ValidationHandler.shared.validate(values: (ValidationType.email, email), (ValidationType.password, password))
        switch validationResponse {
        case .success:
            status = true
            break
        case .failure(_, let message):
            Utility.showHudWithError(errorString: message.localized())
            status = false
            break
        }
        return status
    }
}


extension signinViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print("SUCCEDDED")
        let dict:[String:Any] = data as! [String:Any]
        let status = dict["isError"] as? Bool ?? false
        if(status == true) {
            Utility.showHudWithError(errorString: dict["responseException"] as? String ?? APIErrors.generic.rawValue)
        }
        else {
            if let result = dict["result"] as? [String:Any] {
                let t = Token()
                t.token = result["token"] as? String ?? ""
                t.expiresIn = result["expiresIn"] as? Int ?? 0
                UserPreferences.shared().loggedInToken = t
                UserPreferences.shared().isLoggedIn = true
                APP_DELEGATE.navController.setViewControllers([MainTabVC.instantiate(fromAppStoryboard: .main)], animated: false)
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
