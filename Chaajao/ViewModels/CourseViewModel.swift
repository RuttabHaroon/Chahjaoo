//
//  CourseViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 09/01/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import SwiftUI

class CourseViewModel {
    
    var categories : [[String:Any]] = [[:]]
    var ecatModels = [CoursePickerModel]()
    var bcatModels = [CoursePickerModel]()
    var mcatModels = [CoursePickerModel]()
    var list = [[String:Any]]()

    var onSucess : (()->Void)?
    
    func addCategory(title: String, description: String, count: Int, isExpanded: Bool) {
        var cell = [String:Any]()
        cell["isExpanded"] = isExpanded
        cell["title"] = title
        cell["description"] = description
        cell["count"] = count
        cell["cellType"] = cellType.courseListCell
        self.list.append(cell)
    }
    
    func getStreamList() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .streamList),
                                   parameters: nil,
                                   method: .get,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS)
    }
    
}

extension CourseViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print(data as! ([String:Any]))
        if let streamData = Streamlist.init(JSON: data as! [String:Any], context: nil) {
            print(streamData)
            if let message = streamData.message {
                print(message)
            }
            if let result = streamData.result {
                self.list.removeAll()
                self.bcatModels.removeAll()
                self.mcatModels.removeAll()
                self.ecatModels.removeAll()
                
                for index in 0..<result.count{
                    var shouldIncreaseCount = false
                    result[index].universities?.forEach { el in
                        if (result[index].name ?? "").lowercased() == "ecat" {
                            var selected = false
                            if let _ = el.programs?.firstIndex(where: {$0.id ?? 9 == UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programRelationID ?? 0}) {
                                selected = true
                            }
                            print(el.name ?? "")
                            print(UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.universityName ?? "")
                            if (el.name?.lowercased() ?? "") == (UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.universityName?.lowercased() ?? "") {
                                shouldIncreaseCount = true
                            }
                            self.ecatModels.append(CoursePickerModel.init(instituteName: el.name ?? "",
                                                                          iconName: "nust",
                                                                          isSelected: selected,
                                                                          programs: el.programs
                                                                         ))
                        }
                        else if (result[index].name ?? "").lowercased() == "bcatModels" {
                            var selected = false
                            if let _ = el.programs?.firstIndex(where: {$0.id ?? 9 == UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programRelationID ?? 0}) {
                                selected = true
                            }
                            self.bcatModels.append(CoursePickerModel.init(instituteName: el.name ?? "",
                                                                          iconName: "nust",
                                                                          isSelected: selected,
                                                                          programs:el.programs))
                        }
                        else if (result[index].name ?? "").lowercased() == "mcatModels" {
                            var selected = false
                            if let _ = el.programs?.firstIndex(where: {$0.id ?? 9 == UserPreferences.shared().userModelData?.userCourseData?.courseSelected?.programRelationID ?? 0}) {
                                selected = true
                            }
                            self.mcatModels.append(CoursePickerModel.init(instituteName: el.name ?? "",
                                                                          iconName: "nust",
                                                                          isSelected: selected,
                                                                          programs:el.programs))
                        }
                    }
                    addCategory(title: result[index].name ?? "",
                                description: result[index].resultDescription ?? "",
                                count: shouldIncreaseCount == false ? 0 : 1 ,
                                isExpanded: false)
                    if index == 0 {
                        self.list[index]["items"] = self.ecatModels
                    }
                    else if index == 1 {
                        self.list[index]["items"] = self.bcatModels
                    }
                    else {
                        self.list[index]["items"] = self.mcatModels
                    }
                }
            }
            if let s = onSucess {
                s()
            }
        }
        else {
            Utility.showHudWithError(errorString: APIErrors.generic.rawValue)
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
}
