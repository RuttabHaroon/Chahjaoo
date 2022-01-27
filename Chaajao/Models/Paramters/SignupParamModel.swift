// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let signupParamModel = try? newJSONDecoder().decode(SignupParamModel.self, from: jsonData)

import Foundation

// MARK: - SignupParamModel
struct SignupParamModel: Codable {
    let fullName, phoneNumber, email, password: String
    let confirmPassword, deviceToken, appVersion: String
    
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
}
