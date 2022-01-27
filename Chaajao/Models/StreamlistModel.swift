// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let streamlist = try? newJSONDecoder().decode(Streamlist.self, from: jsonData)

import Foundation
import ObjectMapper

// MARK: - Streamlist
struct Streamlist: Codable, Mappable {
    var message: String?
    var result: [Test]?
    
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
struct Test: Codable, Mappable {
    var id: Int?
    var name: String?
    var resultDescription: String?
    var universities: [University]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case universities
    }
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        resultDescription <- map["description"]
        universities <- map["universities"]
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        resultDescription <- map["description"]
        universities <- map["universities"]
    }
}

// MARK: - University
struct University: Codable, Mappable {
    var id: Int?
    var name, universityDescription: String?
    var logo: String?
    var programs: [Program]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case universityDescription = "description"
        case logo, programs
    }
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        universityDescription <- map["description"]
        logo <- map["logo"]
        programs <- map["programs"]
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        universityDescription <- map["description"]
        logo <- map["logo"]
        programs <- map["programs"]
    }
}
//
//
struct Program: Codable, Mappable {
    var id: Int?
    var name, streamlistDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case streamlistDescription = "description"
    }
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        streamlistDescription <- map["description"]
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        streamlistDescription <- map["description"]
    }
}
