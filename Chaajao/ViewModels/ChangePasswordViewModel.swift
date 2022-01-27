//
//  ChangePasswordVM.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 18/12/2021.
//

import Foundation
import Alamofire


class ChangePasswordViewModel {
    
    var oldPassword = ""
    var newPassword = ""
    var confirmPassword = ""
    var onPasswordUpdateSucess : (()->Void)?
    
    
    private func isValid() ->Bool {
        var status = true
        let validationResponse = ValidationHandler.shared.validate(values:
                                                                   (ValidationType.password, oldPassword),
                                                                   (ValidationType.password, newPassword))
        switch validationResponse {
        case .success:
            if (self.newPassword == self.confirmPassword) {
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
    
    
    func changeThePassword() {
        let p = [
            "oldPassword" : oldPassword,
            "newPassword" : newPassword,
        ] as [String : Any]
        
        if isValid() == false {
            return
        }
        
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .updatePassword),
                                   parameters: p,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
}

extension ChangePasswordViewModel : HTTPRequestDelegate {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    if let p = self.onPasswordUpdateSucess {
                        p()
                    }
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
