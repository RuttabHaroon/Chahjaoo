// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let signinResponse = try? newJSONDecoder().decode(SigninResponse.self, from: jsonData)

import Foundation
import ObjectMapper

// MARK: - Token
class Token: Codable, Mappable {
    var token: String?
    var expiresIn: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
 
    }
 
    func mapping(map: Map) {
        token         <- map["token"]
        expiresIn  <- map["expiresIn"]
    }
    
}
