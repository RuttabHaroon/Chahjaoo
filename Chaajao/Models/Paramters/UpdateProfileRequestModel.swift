// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let updateProfileRequestModel = try? newJSONDecoder().decode(UpdateProfileRequestModel.self, from: jsonData)

import Foundation
import ObjectMapper

// MARK: - UpdateProfileRequestModel
class UpdateProfileRequestModel: Codable, Mappable {
    
    var name, email, whatsappNumber, phoneNumber: String?
    var gender, dob, address, country: String?
    var city, lastInstitute, profileImage: String?
    var isOnCampus: Bool?
    var degrees: [Degree]?
    var userCourseData: UserCourseData?
    
    required init?(map: Map) {

    }
    

    
    func mapping(map: Map) {
        name    <- map["name"]
        email         <- map["email"]
        whatsappNumber      <- map["whatsappNumber"]
        phoneNumber       <- map["phoneNumber"]
        gender  <- map["gender"]
        dob  <- map["dob"]
        address     <- map["address"]
        country    <- (map["country"])
        city    <- map["city"]
        lastInstitute         <- map["lastInstitute"]
        profileImage      <- map["profileImage"]
        isOnCampus       <- map["isOnCampus"]
        degrees  <- map["degrees"]
        userCourseData  <- map["userCourseData"]
    }
    
    
}

// MARK: - Degree
class Degree: Codable, Mappable {
    var title, grade: String?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        title    <- map["title"]
        grade         <- map["grade"]
    }
}


// MARK: - CourseSelected
class CourseSelected: Codable, Mappable {
    var isPurchased: Bool?
    var programRelationID: Int?
    var programName, universityName, streamName: String?

    enum CodingKeys: String, CodingKey {
        case isPurchased
        case programRelationID = "programRelationId"
        case programName, universityName, streamName
    }
    
    required init?(map: Map) {
        isPurchased    <- map["isPurchased"]
        programRelationID         <- map["programRelationId"]
        programName    <- map["programName"]
        universityName    <- map["universityName"]
        streamName         <- map["streamName"]
    }
    
    func mapping(map: Map) {
        isPurchased    <- map["isPurchased"]
        programRelationID         <- map["programRelationId"]
        programName    <- map["programName"]
        universityName    <- map["universityName"]
        streamName         <- map["streamName"]
    }

}
