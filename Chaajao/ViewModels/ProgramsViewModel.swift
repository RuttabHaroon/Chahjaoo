//
//  ProgramsViewModel.swift
//  Chaajao
//
//  Created by Q.M.S on 30/12/2021.
//

import Foundation
import Alamofire

class ProgramsViewModel {
    
    var reloadData: (() -> Void)?
    
    var onUserSelectedProgramsFetched: (([Int])->Void)?
    
    var programID = 0
    var courseList : CoursePickerModel?
    
    
    func getData() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .programList),
                                   parameters: nil,
                                   method: .get,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS)
    }
    
    
    func updateCourse() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .updateSelectedCourse),
                                   parameters: ["programId":programID],
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
}

extension ProgramsViewModel: HTTPRequestDelegate {
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
                Utility.showHudWithSuccess(sucessString: result)
            }
            print(dict)
            if httpRequest.debugDescription == "[HTTPRequest] [get] http://66.135.44.131:91/api/User/getProgramsListForUser: http://66.135.44.131:91/api/User/getProgramsListForUser" {
                var selectedProgramIDs : [Int] = []
                if let selectedProgramList = dict["result"] as? [[String:Any]] {
                    selectedProgramList.forEach({selectedProgramIDs.append($0["id"] as? Int ?? 0)})
                    if let u = onUserSelectedProgramsFetched {
                        u(selectedProgramIDs)
                    }
                }
            }
            else {
                if let r = dict["result"] as? [String:Any] {
                    sendNotification(notificationName: "navigateToHome")
                    APP_DELEGATE.navController.popToRootViewController(animated: true)
                    reloadData?()
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
