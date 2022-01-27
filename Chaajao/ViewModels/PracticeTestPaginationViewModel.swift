//
//  PracticeTestPaginationViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 18/01/2022.
//

import Alamofire

class PracticeTestPaginationViewModel {

    var onDataLoaded : (()->Void)?
    var dataArray : [TestTypeResult] = []
    var testType = 0
    
    init() {
        getData()
    }
    
    func getData() {
        let params = [
            "testType": UserPreferences.shared().userPickedTestType,
            "programId": UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programRelationID ?? 0
        ]
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .getSubjectDDetailsForAnyTestType),
                                   parameters: params,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
    
}


extension PracticeTestPaginationViewModel : HTTPRequestDelegate {
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
            print(dict)
            if let resultArr = dict["result"] as? [[String:Any]] {
                resultArr.forEach { i in
                    if let streamData = TestTypeResult.init(JSON:i, context: nil) {
                        print(streamData.name ?? "")
                        dataArray.append(streamData)
                        print(dataArray.count)
                    }
                }
                if let d = onDataLoaded {
                    d()
                }
                print(dataArray)
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
