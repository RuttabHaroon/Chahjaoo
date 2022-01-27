// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let testDetailResponseModel = try? newJSONDecoder().decode(TestDetailResponseModel.self, from: jsonData)

import Foundation
import ObjectMapper

// MARK: - TestDetailResponseModel
struct TestDetailResponseModel: Codable {
    var message: String?
    var result: TestDetail?
}

// MARK: - Result
struct TestDetail: Codable, Mappable {
    var id: Int?
    var name: String?
    var grandTestType: Int?
    var testSections: [TestSection]?
    
    init?(map: Map) {
        id <- map["id"]
        name <- map["name"]
        grandTestType <- map["grandTestType"]
        testSections <- map["testSections"]
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        grandTestType <- map["grandTestType"]
        testSections <- map["testSections"]
    }
    
}

// MARK: - TestSection
struct TestSection: Codable, Mappable {
    var sectionID: Int?
    var sectionTitle, sectionContent: String?
    var totalTime, totalQuestions: Int?
    var testSectionPoints: [String]?
    var testSectionQuestions: [TestSectionQuestion]?

    enum CodingKeys: String, CodingKey {
        case sectionID = "sectionId"
        case sectionTitle, sectionContent, totalTime, totalQuestions, testSectionPoints, testSectionQuestions
    }
    
    init?(map: Map) {
        sectionID <- map["sectionId"]
        sectionTitle <- map["sectionTitle"]
        sectionContent <- map["sectionContent"]
        totalTime <- map["totalTime"]
        totalQuestions <- map["totalQuestions"]
        testSectionPoints <- map["testSectionPoints"]
        testSectionQuestions <- map["testSectionQuestions"]
    }
    
    mutating func mapping(map: Map) {
        sectionID <- map["sectionId"]
        sectionTitle <- map["sectionTitle"]
        sectionContent <- map["sectionContent"]
        totalTime <- map["totalTime"]
        totalQuestions <- map["totalQuestions"]
        testSectionPoints <- map["testSectionPoints"]
        testSectionQuestions <- map["testSectionQuestions"]
    }
}

// MARK: - TestSectionQuestion
struct TestSectionQuestion: Codable, Mappable {
    var questionID: Int?
    var questionText, questionCode, questionImage, solutionVideo: String?
    var questionType: Int?
    var difficultyLevel: String?
    var parentID: Int?
    var isBookmarked: Bool?
    var answers: [TestAnswer]?

    enum CodingKeys: String, CodingKey {
        case questionID = "questionId"
        case questionText, questionCode, questionImage, solutionVideo, questionType, difficultyLevel
        case parentID = "parentId"
        case isBookmarked, answers
    }
    
    init?(map: Map) {
        questionID <- map["questionId"]
        questionText <- map["questionText"]
        questionCode <- map["questionCode"]
        questionImage <- map["questionImage"]
        solutionVideo <- map["solutionVideo"]
        questionType <- map["questionType"]
        difficultyLevel <- map["difficultyLevel"]
        parentID <- map["parentId"]
        isBookmarked <- map["isBookmarked"]
        answers <- map["answers"]
    }
    
    mutating func mapping(map: Map) {
        questionID <- map["questionId"]
        questionText <- map["questionText"]
        questionCode <- map["questionCode"]
        questionImage <- map["questionImage"]
        solutionVideo <- map["solutionVideo"]
        questionType <- map["questionType"]
        difficultyLevel <- map["difficultyLevel"]
        parentID <- map["parentId"]
        isBookmarked <- map["isBookmarked"]
        answers <- map["answers"]
    }
}

// MARK: - Answer
struct TestAnswer: Codable, Mappable {
    var answerID: Int?
    var answerText, answerImage: String?
    var isCorrect: Bool?
    var solutionText: String?
    var questionID: Int?

    enum CodingKeys: String, CodingKey {
        case answerID = "answerId"
        case answerText, answerImage, isCorrect, solutionText
    }
    
    init?(map: Map) {
        answerID <- map["answerId"]
        answerText <- map["answerText"]
        answerImage <- map["answerImage"]
        isCorrect <- map["isCorrect"]
        solutionText <- map["solutionText"]
    }
    
    mutating func mapping(map: Map) {
        answerID <- map["answerId"]
        answerText <- map["answerText"]
        answerImage <- map["answerImage"]
        isCorrect <- map["isCorrect"]
        solutionText <- map["solutionText"]
    }
}
