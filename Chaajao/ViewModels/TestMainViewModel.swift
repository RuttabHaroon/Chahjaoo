//
//  TestMainViewModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 20/01/2022.
//

import Alamofire
import SwiftyJSON
import ObjectMapper

class TestMainViewModel  {
    
    var requestModel : [String:Any] = [:]
    var onComplete: ((Bool)->Void)?
    
    func submitTest(testData : TestDetail,questionModel: [QuestionModel]) {
        var totalTimeTaken = 0
        var questions : [[String:Any]] = []
        questionModel.forEach({ q in
            var answers : [[String:Any]] = []
            
            if q.questionType == 2 {
                var answer : [String:Any] = [:]
                answer["answerId"] = 0
                answer["isSelected"] = true
                answer["answerText"] = q.questionAnswerTyped
                answers.append(answer)
            }
            else {
                let correctAnswers  = q.answers.filter({$0.isSelected == true})
                correctAnswers.forEach({ a in
                    var answer : [String:Any] = [:]
                    answer["answerId"] = a.answerID
                    answer["isSelected"] = a.isSelected
                    answer["answerText"] = a.text
                    answers.append(answer)
                })
            }
            
            var question : [String: Any] = [:]
            question["questionId"] = q.questionID
            question["totalTimeTaken"] = q.timeTaken
            question["isBookmarked"] = q.isBookmarked
            question["answerList"] = answers
            questions.append(question)
            totalTimeTaken += q.timeTaken
        })
        
        var sectionList : [[String:Any]] = []
        var section : [String: Any] = [:]
        section["sectionId"] = testData.testSections?[0].sectionID ?? 0
        section["totalTimeTaken"] =  totalTimeTaken
        section["questionList"] = questions
        sectionList.append(section)
        
        requestModel["testId"] = testData.id ?? 0
        requestModel["sectionList"] = sectionList
        

        
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .submitTest),
                                   parameters: requestModel,
                                   method: .post,
                                   showHud: true,
                                   delegate: self,
                                   otherData: nil,
                                   encoding: JSONEncoding.default,
                                   headers: NetworkClient.APP_HEADERS_THIRD)
    }
}

extension TestMainViewModel : HTTPRequestDelegate {
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
        if let c = onComplete {
            c(false)
        }
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print("SUCCEDDED")
        let dict:[String:Any] = data as! [String:Any]
        if((dict["isError"] != nil) == true) {
            Utility.showHudWithError(errorString: dict["responseException"] as? String ?? APIErrors.generic.rawValue)
            if let c = onComplete {
                c(false)
            }
        }
        else {
            if let result = dict["message"] as? String {
                print(result)
                if let c = onComplete {
                    c(true)
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
        if let c = onComplete {
            c(false)
        }
    }
}
