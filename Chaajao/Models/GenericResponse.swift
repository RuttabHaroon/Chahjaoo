// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let genericResponse = try? newJSONDecoder().decode(GenericResponse.self, from: jsonData)

import Foundation

// MARK: - GenericResponse
struct GenericResponse: Codable {
    let message: String
    let isError: Bool
    let responseException: String
}
