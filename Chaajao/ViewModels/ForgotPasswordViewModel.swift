//
//  ForgotPasswordViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 16/12/2021.
//

import Foundation
import Alamofire

class ForgotPasswordViewModel {
    
    var email = ""
    
    func sendForgotPasswordRequest() {
        
        if(isValid()==false) {
            return
        }

        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .forgotpassword),
                                   parameters: ["email": email],
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
    }
    
    private func isValid() ->Bool {
        var status = true
        let validationResponse = ValidationHandler.shared.validate(values:
                                                                   (ValidationType.email, email))
        switch validationResponse {
        case .success:
            status = true
            break
        case .failure(_, let message):
            status = false
            Utility.showHudWithSuccess(sucessString: message.rawValue)
            break
        }
        return status
    }
    
    
}


extension ForgotPasswordViewModel : HTTPRequestDelegate {
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
            if let result = dict["message"] as? String {
                Utility.showHudWithSuccess(sucessString: result)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let otpVc  = OtpVC.instantiate(fromAppStoryboard: .userAccess)
                    otpVc.vm.email = self.email
                    otpVc.vm.comingFromVC = .forgotPassword
                    APP_DELEGATE.navController.pushViewController(otpVc, animated: true)
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
