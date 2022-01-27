//
//  UserViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 19/12/2021.
//

import Foundation
import Alamofire

class UserViewModel {
    
    var userModelUpdated: (()->Void)?
    
    func getUserProfile() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .personalprofile),
                                   parameters: nil,
                                   method: .get,
                                   showHud: false,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS)
    }
}



extension UserViewModel : HTTPRequestDelegate {
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
                print("i")
            }
            if let result = dict["result"] as? [String:Any] {
                let u = User(JSON: result, context: nil)
                print(u?.name)
                if let uData = u {
                   UserPreferences.shared().userModelData = uData
                }
                if let u = userModelUpdated {
                    u()
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
