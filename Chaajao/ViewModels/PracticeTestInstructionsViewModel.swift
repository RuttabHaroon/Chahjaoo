//
//  PracticeTestInstructionsViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 19/01/2022.
//

import Alamofire

class PracticeTestInstructionsViewModel {
    
    var onDataFetched: (()->Void)?
    var testDetail: TestDetail?
    
    func getData(testID: Int) {
        let params = [
            "testId": testID,
            "testType": UserPreferences.shared().userPickedTestType
        ]
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .getTestDetails),
                                   parameters: params,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
    
}


extension PracticeTestInstructionsViewModel : HTTPRequestDelegate {
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
            if let r = dict["result"] as? [String:Any] {
                let t = TestDetail(JSON: r, context: nil)
                self.testDetail = t
                if let sucess = onDataFetched{
                    sucess()
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
