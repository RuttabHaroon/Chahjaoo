//
//  ProfileViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 10/01/2022.
//

import Foundation
import Alamofire
import UIKit

class ProfileViewModel {
    
    var onProfilePictUpdated: ((String)->Void)?
    
    func updateProfilePic(image: UIImage) {
        //let image = UIImage.init(named: "nust")
        HTTPServiceManager.imageUpload(imageoUpload: image, requestURl: "", delegate: self)
    }
    
}


extension ProfileViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print(data as! ([String:Any]))
        if let streamData = Streamlist.init(JSON: data as! [String:Any], context: nil) {
            print(streamData)
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func imageUploadRequestDidFailWithError(error: NSError) {
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func imageUploadRequestDidSucceedWithData(data: [String : String]?) {
        print("photo url =>" + (data?["photo"] ?? ""))
        Utility.showHudWithSuccess(sucessString: data?["message"] ?? "")
//        if let p = onProfilePictUpdated {
//            p((data?["photo"] ?? "")
//        }
    }
}
