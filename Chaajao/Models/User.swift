//
//  User.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 19/12/2021.
//

import Foundation
import ObjectMapper


class User: Codable, Mappable {
    
    var gender: String?
    var whatsappNumber: String?
    var country: String?
    var degrees: String?
    var lastInstitute: String?
    var dob: String?
    var address: String?
    var userCourseData: UserCourseData?
    var city: String?
    var profileImage: String?
    var email: String?
    var name: String?
    var phoneNumber: String?
    var isOnCampus: Bool?
 

    required init?(map: Map) {
 
    }
    
    func mapping(map: Map) {
        gender    <- map["gender"]
        whatsappNumber         <- map["whatsappNumber"]
        country      <- map["country"]
        degrees       <- map["degrees"]
        lastInstitute  <- map["lastInstitute"]
        dob  <- map["dob"]
        address     <- map["address"]
        userCourseData    <- map["userCourseData"]
        city  <- map["city"]
        profileImage  <- map["profileImage"]
        email     <- map["email"]
        name    <- map["name"]
        phoneNumber <- map["phoneNumber"]
        isOnCampus <- map["isOnCampus"]
    }
    
}


class UserCourseData : Codable, Mappable {
    var isPremium : Int?
    var hasSelectedProgram: Int?
    var courseSelected: CourseSelected?
    var userId : String?
    var isOnCampus: Bool?
    
    required init?(map: Map) {
 
    }
    
    func mapping(map: Map) {
        isPremium    <- map["isPremium"]
        hasSelectedProgram         <- map["hasSelectedProgram"]
        courseSelected      <- map["courseSelected"]
        userId       <- map["userId"]
        isOnCampus <- map["isOnCampus"]
    }
}


