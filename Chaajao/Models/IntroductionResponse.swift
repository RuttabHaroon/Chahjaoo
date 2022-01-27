// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let introductionResponse = try? newJSONDecoder().decode(IntroductionResponse.self, from: jsonData)

import Foundation


// MARK: - IntroductionResponse
struct IntroductionResponse: Codable {
    let message: String
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let title, subTitle, startDate, endDate: String
    let description: String
    let link: String
    let type: String
    let buttonText: String?
    let buttonLink: String?

    enum CodingKeys: String, CodingKey {
        case id, title, subTitle, startDate, endDate
        case description = "description"
        case link, type, buttonText, buttonLink
    }
}
