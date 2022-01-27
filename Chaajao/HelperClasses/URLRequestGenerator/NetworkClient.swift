//
//  URLRequestGenerator.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 11/12/2021.
//

import Foundation
import Alamofire

class NetworkClient {
    
    static private let BASE_URL = "http://66.135.44.131:91/api/"
    
    static var APP_HEADERS : HTTPHeaders = {
        var headers : HTTPHeaders = [:]
        headers["Content-Type"] = "text/plain"
        headers["Accept"]="application/json"
        headers["Authorization"] = "Bearer \(UserPreferences.shared().loggedInToken.token ?? "")"
        return headers
    }()
    
    static var APP_HEADERS_SECOND : HTTPHeaders = {
        var headers : HTTPHeaders = [:]
        headers["Content-Type"] = "application/json"
        headers["Accept"]="text/plain"
        headers["Authorization"] = "Bearer \(UserPreferences.shared().loggedInToken.token ?? "")"
        return headers
    }()
    
    static var APP_HEADERS_THIRD : HTTPHeaders = {
        var headers : HTTPHeaders = [:]
        headers["Authorization"] = "Bearer \(UserPreferences.shared().loggedInToken.token ?? "")"
        return headers
    }()
    
    static var APP_HEADERS_FOURTH : HTTPHeaders = {
        var headers : HTTPHeaders = [:]
        headers["Accept"]="text/plain"
        headers["Authorization"] = "Bearer \(UserPreferences.shared().loggedInToken.token ?? "")"
        return headers
    }()
    
    static var APP_HEADERS_IMAGE_UPLOAD : HTTPHeaders = {
        var headers : HTTPHeaders = [:]
        headers["Accept"]="text/plain"
        headers["Authorization"] = "Bearer \(UserPreferences.shared().loggedInToken.token ?? "")"
        headers["Content-Type"] = "multipart/form-data"
        return headers
    }()
    
    enum URLRoutes: String {
        case signup = "Authentication/signup"
        case signIn = "Authentication/signIn"
        case introscreen = "Common/introscreen"
        case resendotpcode = "Authentication/resendotpcode"
        case verifyotp = "Authentication/verifyotp"
        case forgotpassword = "Authentication/forgotpassword"
        case personalprofile = "User/personalprofile"
        case updatePassword = "User/UpdatePassword"
        case contactUs = "User/contactus"
        case newsAdd = "User/getNewsAds"
        case programList = "User/getProgramsListForUser"
        case streamList = "Common/streamlist"
        case updateProfilePicture = "User/updateprofileimage"
        case updateSelectedCourse = "User/updateSelectedCourse"
        case getSubjectDDetailsForAnyTestType = "Tests/getSubjectDDetailsForAnyTestType"
        case getTestDetails = "Tests/getTestDetails"
        case submitTest = "Tests/submitTest"
        //case userCourseData = "User/userCourseData"
        
        //user block
        case updateprofile = "User/updateprofile"
    }

        
    class func getAPIUrl(route: URLRoutes) -> String {
        return BASE_URL + route.rawValue
    }
    
}
