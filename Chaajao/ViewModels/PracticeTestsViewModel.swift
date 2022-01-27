//
//  File.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 17/01/2022.
//

import Alamofire

class PracticeTestsViewModel {
    
    var dropwDownDatalist = [DropDownData]()
    
    init() {
        getData()
        
    }
    
}

extension PracticeTestsViewModel {
    func getData() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .streamList),
                                   parameters: nil,
                                   method: .get,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS)
    }
    
    func updateCourse(userSelectedProgramID : Int) {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .updateSelectedCourse),
                                   parameters: ["programId":userSelectedProgramID],
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
}


extension PracticeTestsViewModel: HTTPRequestDelegate {
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
            
            print(httpRequest.urlString)
            if httpRequest.urlString == "http://66.135.44.131:91/api/User/updateSelectedCourse" {
                if let result = dict["result"] as? [String:Any] {
                    let updated = CourseSelected(JSON: result, context: nil)
                    //let u = User(JSON: result, context: nil)
                    if let uData = updated {
                        print(UserPreferences.shared().userModelData!.userCourseData!.courseSelected)
                        UserPreferences.shared().userModelData?.userCourseData?.courseSelected = uData
                    }
                }
            }
            else {

                if let streamData = Streamlist.init(JSON: data as! [String:Any], context: nil) {
                    print(streamData)
                    if let message = streamData.message {
                        print(message)
                    }
                    if let result = streamData.result {
                        result.forEach { t in
                            t.universities?.forEach({ u in
                                u.programs?.forEach({ p in
                                    let name = "\(p.streamlistDescription ?? "") - \(u.name ?? "")"
                                    self.dropwDownDatalist.append(DropDownData(ischecked: false, titeValue: name, Id: p.id ?? 0))
                                })
                            })
                        }
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
