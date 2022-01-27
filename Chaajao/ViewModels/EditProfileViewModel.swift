//
//  EditProfileViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 09/01/2022.
//

import Foundation
import Alamofire
import ObjectMapper

class EditProfileViewModel {
    
    var name, email, whatsappNumber, phoneNumber: String?
    var gender, dob, address, country: String?
    var city, lastInstitute, profileImage: String?
    var isOnCampus: Bool?
    var degrees: [Degree]?
    var userCourseData: UserCourseData?
    
    
    func updateProfileUsingAPI() {
        
//        if isValid() == false {
//            return
//        }
//
        let params : [String:Any] = [
            "name":name ?? "",
            "email":email ?? "",
            "whatsappNumber":whatsappNumber ?? "",
            "phoneNumber":phoneNumber ?? "",
            "gender": gender ?? "",
            "dob":dob ?? "",
            "address":address ?? "",
            "country":country ?? "",
            "city":city ?? "",
            "lastInstitute":lastInstitute ?? "",
            "profileImage":profileImage ?? "",
            "isOnCampus": true,
            "degrees":degrees ?? [],
            "userCourseData":userCourseData ?? []
        ]
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .updateprofile),
                                   parameters: params,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS)
    }
    
    private func isValid() ->Bool {
        
        if let name = name,
        let email = email,
        let whatsapp = whatsappNumber,
        let phoneNumber = phoneNumber
        {
            var status = true
            let validationResponse = ValidationHandler.shared.validate(values:
                                                                        (ValidationType.fullname, name),
                                                                        (ValidationType.email, email),
                                                                       (ValidationType.phoneNo, whatsapp),
                                                                       (ValidationType.phoneNo, phoneNumber))
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
        return false
    }
    
}

extension EditProfileViewModel : HTTPRequestDelegate {
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
            Utility.showHudWithSuccess(sucessString: "Profile Updated")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                APP_DELEGATE.navController.popViewController(animated: true)
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}

