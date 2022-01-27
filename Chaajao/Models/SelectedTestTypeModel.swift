//
//  SelectedTestTypeModel.swift
//  Chaajao
//
//  Created by Ruttab Haroon on 18/01/2022.
//

import ObjectMapper
import Alamofire

struct TestTypeModel: Codable, Mappable {
    var message: String?
    var result: [TestTypeResult]?
    
    init?(map: Map) {
        message <- map["message"]
        result <- map["result"]
    }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        result <- map["result"]
    }
}

// MARK: - Result
struct TestTypeResult: Codable, Mappable {
    var id: Int?
    var name: String?
    var chapters: [TestTypeResult]?
    var tests: [TestShortDetail]?
    var topics: [String]?
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        chapters <- map["chapters"]
        tests <- map["tests"]
        topics <- map["topics"]
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        chapters <- map["chapters"]
        tests <- map["tests"]
        topics <- map["topics"]
    }
    
}

// MARK: - Test
struct TestShortDetail: Codable, Mappable {
    var id: Int?
    var name: String?
    var totalTime: Int?
    var isClassTest, isSample, isAlreadyTaken, isPurchased: Bool?
    var isGrandTest: Bool?
    var totalQuestion, scheduleAt, expireAt: Int?
    var isSortable: Bool?
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        totalTime <- map["totalTime"]
        isClassTest <- map["isClassTest"]
        isSample <- map["isSample"]
        isAlreadyTaken <- map["isAlreadyTaken"]
        isPurchased <- map["isPurchased"]
        isGrandTest <- map["isGrandTest"]
        totalQuestion <- map["totalQuestion"]
        scheduleAt <- map["scheduleAt"]
        expireAt <- map["expireAt"]
        isSortable <- map["isSortable"]
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        totalTime <- map["totalTime"]
        isClassTest <- map["isClassTest"]
        isSample <- map["isSample"]
        isAlreadyTaken <- map["isAlreadyTaken"]
        isPurchased <- map["isPurchased"]
        isGrandTest <- map["isGrandTest"]
        totalQuestion <- map["totalQuestion"]
        scheduleAt <- map["scheduleAt"]
        expireAt <- map["expireAt"]
        isSortable <- map["isSortable"]
    }
    
}

