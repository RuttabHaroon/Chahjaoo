//
//  OTPViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 15/12/2021.
//

import Foundation
import Alamofire


class OTPViewModel {
    
    var email = ""
    var otpCode = ""
    var deviceToken = "" //UserPreferences.loggedInToken
    var appVersion = "appVersion"
    var vc: OtpVC?
    var comingFromVC : ComingFrom = .signup
    
    
    func resentOTP() {
        self.vc?.toggleStatusView(loading: true)
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .resendotpcode),
                                   parameters: ["email": email],
                                   method: .post,
                                   showHud: false,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
    }
    
    func verifyOTP() {
        let p = [
            "email" : email,
            "otpCode" : otpCode,
            "deviceToken" : deviceToken,
            "appVersion" : appVersion,
        ] as [String : Any]
        self.vc?.toggleStatusView(loading: true)
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .verifyotp),
                                   parameters: p,
                                   method: .post,
                                   showHud: false,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
    }
    
    

//    
//    func getPersonalProfile() {
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZjE4YmQxYy02MmJjLTQzZWQtOTljZS05ZDc2ODM3ZTdkMjUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidXM2NmVyQGV4NzFhbXBsZS5jb20iLCJqdGkiOiJkNGZhNGI4Yy0zMmFmLTQ0OWQtYmZjYi1lMmM3YjM5OTQyNWEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjJmMThiZDFjLTYyYmMtNDNlZC05OWNlLTlkNzY4MzdlN2QyNSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2dpdmVubmFtZSI6IjUxNSIsImV4cCI6MTcyNjE2MzM5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMTQvIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMTQvIn0.wIwTcQsOHFJuW_di1ltp5VRSzFhXF50ky7TSx5tLdaA"
//        let url = URL(string: "http://66.135.44.131:91/api/User/personalprofile")!
//
//
//        // create post request
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        var a : HTTPHeaders = [:]
//        a["Content-Type"] = "text/plain"
//        a["Accept"]="application/json"
//        a["Authorization"] = "Bearer \(token)"
//        
//        
//        Alamofire.request(URL(string: "http://66.135.44.131:91/api/User/personalprofile")!,
//                          method: .get,
//                          parameters: nil,
//                          encoding: JSONEncoding.default,
//                          headers: a)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.result.value{
//                    // Response type-1
//                    if  (data as? [[String : AnyObject]]) != nil{
//                        print("data_1: \(data)")
//                    }
//                    // Response type-2
//                    if  (data as? [String : AnyObject]) != nil{
//                        print("data_2: \(data)")
//                    }
//                }
//        }
//        
//    }
    
//    func updatePassword() {
//        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZjE4YmQxYy02MmJjLTQzZWQtOTljZS05ZDc2ODM3ZTdkMjUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidXM2NmVyQGV4NzFhbXBsZS5jb20iLCJqdGkiOiJkNGZhNGI4Yy0zMmFmLTQ0OWQtYmZjYi1lMmM3YjM5OTQyNWEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjJmMThiZDFjLTYyYmMtNDNlZC05OWNlLTlkNzY4MzdlN2QyNSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2dpdmVubmFtZSI6IjUxNSIsImV4cCI6MTcyNjE2MzM5MywiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMTQvIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NDQzMTQvIn0.wIwTcQsOHFJuW_di1ltp5VRSzFhXF50ky7TSx5tLdaA"
//
//        var a : HTTPHeaders = [:]
//        a["Content-Type"] = "application/json"
//        a["Accept"]="text/plain"
//        a["Authorization"] = "Bearer \(token)"
//
//
//        Alamofire.request(URL(string: "http://66.135.44.131:91/api/User/UpdatePassword")!,
//                          method: .post,
//                          parameters: ["oldPassword":"stringAs223!Z", "newPassword":"Zane3@@"],
//                          encoding: JSONEncoding.default,
//                          headers: a)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.result.value{
//                    // Response type-1
//                    if  (data as? [[String : AnyObject]]) != nil{
//                        print("data_1: \(data)")
//                    }
//                    // Response type-2
//                    if  (data as? [String : AnyObject]) != nil{
//                        print("data_2: \(data)")
//                    }
//                }
//        }
//
//    }
    
}

extension OTPViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        self.vc?.toggleStatusView(loading: false, otpState: .error)
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print("SUCCEDDED")
        let dict:[String:Any] = data as! [String:Any]
        let status = dict["isError"] as? Bool ?? false
        if(status == true) {
            self.vc?.toggleStatusView(loading: false, otpState: .error)
            Utility.showHudWithError(errorString: dict["responseException"] as? String ?? APIErrors.generic.rawValue)
        }
        else {
            if httpRequest.requestName.contains("Authentication/verifyotp") {
                self.vc?.toggleStatusView(loading: true)
                let messasge = dict["message"] as? String ?? ""
                print("Message")
                if let result = dict["result"] as? [String:Any] {
                    let t = Token()
                    t.token = result["token"] as? String ?? ""
                    t.expiresIn = result["expiresIn"] as? Int ?? 0
                    UserPreferences.shared().loggedInToken = t
                    UserPreferences.shared().isLoggedIn = true
                }
                delay(1, closure: {
                    self.vc?.toggleStatusView(loading: false, otpState: .verified)
                    if self.comingFromVC == .signup {
                        self.vc?.goToEditMyProfile()
                    }
                    else {
                        APP_DELEGATE.navController.setViewControllers([MainTabVC.instantiate(fromAppStoryboard: .main)], animated: false)
                    }
                })
            }
            else {
                vc?.toggleStatusView(loading: false)
                delay(1, closure: {
                    self.vc?.toggleStatusView(loading: false, otpState: .sent)
                })
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        self.vc?.toggleStatusView(loading: false, otpState: .error)
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
