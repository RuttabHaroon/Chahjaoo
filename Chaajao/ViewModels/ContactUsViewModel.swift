//
//  ContactUsViewModel.swift
//  Chaajao
//
//  Created by Q.M.S on 30/12/2021.
//

import Foundation
import Alamofire

class ContactUsViewModel {
    
    var model: ContactUsModel!
    
    func submitData() {
        
        let params = [
            "name": model.name,
            "email": model.email,
            "messageImage": model.messageImage,
            "phoneNumber": model.phoneNumber,
            "message": model.message,
            "deviceToken": model.deviceToken,
            "appVersion": model.appVersion
        ]
        
        HTTPServiceManager.sharedInstance.request(requestName: NetworkClient.getAPIUrl(route: .contactUs), parameters: params, method: .post, showHud: true, delegate: self, otherData: nil, encoding: JSONEncoding.default, headers: NetworkClient.APP_HEADERS)
        
    }
}

extension ContactUsViewModel: HTTPRequestDelegate {
    
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
                print(result)
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
}
