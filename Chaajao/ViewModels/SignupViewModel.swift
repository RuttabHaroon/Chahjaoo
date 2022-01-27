//
//  SignupViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 10/12/2021.
//

import Foundation
import Alamofire
class SignupViewModel {
    
    var name: String = ""
    var email: String = ""
    var whatsapp_number: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    

    func signupUser() {
        
        if(isValid()==false) {
            return
        }

        
        let p = [
            "fullName" : name,
            "email" : email,
            "phoneNumber" : whatsapp_number,
            "password" : password,
            "confirmPassword": confirmPassword,
            "deviceToken": "string",
            "appVersion": "string"
        ]
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .signup),
                                   parameters: p,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
    }
    
    private func isValid() ->Bool {
        var status = true
        let validationResponse = ValidationHandler.shared.validate(values:
                                                                   (ValidationType.fullname, name),
                                                                   (ValidationType.email, email),
                                                                   (ValidationType.phoneNo, whatsapp_number),
                                                                    (ValidationType.password, password))
        switch validationResponse {
        case .success:
            if (self.password == self.confirmPassword) {
                status = true
            }
            else {
                status = false
            }
            
            break
        case .failure(_, let message):
            Utility.showHudWithError(errorString: message.localized())
            status = false
            break
        }
        return status
    }
    
}


extension SignupViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print("SUCCEDDED")
        let dict:[String:Any] = data as! [String:Any]
        if((dict["isError"] != nil) == true) {
            Utility.showHudWithError(errorString: dict["responseException"] as? String ?? APIErrors.generic.rawValue)
        }
        else {
            if let result = dict["result"] as? [String:Any] {
                let t = Token()
                t.token = result["token"] as? String ?? ""
                t.expiresIn = result["expiresIn"] as? Int ?? 0
                UserPreferences.shared().loggedInToken = t
                UserPreferences.shared().isLoggedIn = true
//                let otpVc  = OtpVC.instantiate(fromAppStoryboard: .userAccess)
//                otpVc.vm.email = self.email
//                APP_DELEGATE.navController.pushViewController(otpVc, animated: true)
            }
            let otpVc  = OtpVC.instantiate(fromAppStoryboard: .userAccess)
            otpVc.vm.email = self.email
            APP_DELEGATE.navController.pushViewController(otpVc, animated: true)
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
