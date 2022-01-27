//
//  QuestionViewModel.swift
//  Chaajao
//
//  Created by Ahmed Khan on 05/10/2021.
//

import Foundation

class QuestionViewModel {
	var items = [QuestionModel]()
	var itemsUpdated:()->Void = {}
	var count = 0 {
		didSet {
			self.itemsUpdated()
		}
	}

	func getData(isSolution: Bool = false) {
		items.removeAll()
		let answers = [
            AnswerModel(answerID: 0, text: "1", reason: "Solution:\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tincidunt, ex vel interdum blandit, lorem felis feugiat elit, in iaculis dui est vel lectus. Proin convallis at ex aliquam commodo.", imageLink: "", isCorrect: true, shouldExpand: isSolution, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
			AnswerModel(answerID: 0, text: "3", reason: "", imageLink: "", isCorrect: false, shouldExpand: isSolution, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
			AnswerModel(answerID: 0, text: "7", reason: "", imageLink: "", isCorrect: false, shouldExpand: false, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
			AnswerModel(answerID: 0, text: "9", reason: "", imageLink: "", isCorrect: false, shouldExpand: false, isSelected: false, questionID: 0, questionDiffcultyLevel: "")]
		let question = "Find the number of terms of the given sequence 32, 24, 16, 8.. for which the sum of the terms is Zero."
		for _ in 0..<5 {
            items.append(QuestionModel(questionID: 0,
                                       text: question,
                                       img: nil,
                                       category: "Topical Test - Math - Chapter 1",
                                       answers: answers,
                                       isBookmarked: false,
                                       timeTaken: 0,
                                       questionType: 0,
                                       questionAnswerTyped: "",
                                       questionDiffcultyLevel: "")
            )
		}
		count = items.count
	}
    
    func getData(isSolution: Bool = false, testDetail: TestDetail) {
        items.removeAll()
        var i = 0
        testDetail.testSections?[0].testSectionQuestions?.forEach({ q in
            var answers : [AnswerModel] = []
            q.answers?.forEach({ a in
                answers.append(
                    AnswerModel(answerID: a.answerID ?? 0,
                                text: a.answerText ?? "",
                                reason: String(a.answerID ?? 0),
                                imageLink: a.answerImage ?? "",
                                isCorrect: a.isCorrect ?? false,
                                shouldExpand: false,
                                isSelected: false,
                                questionID: q.questionID ?? 0,
                                questionDiffcultyLevel: q.difficultyLevel ?? "")
                )
            })
            

            items.append(QuestionModel(questionID: q.questionID ?? 0,
                                       text: q.questionText ?? "",
                                       img: q.questionImage ?? "",
                                       category: "Topical Test - Math - Chapter 1",
                                       answers: answers,
                                       isBookmarked: false,
                                       timeTaken: 0,
                                       questionType: q.questionType ?? 0,
                                       questionAnswerTyped: "",
                                       questionDiffcultyLevel: q.difficultyLevel ?? "")) //questionAnswerTyped is for qwhen user types answer in textview
        })
        count = items.count
    }
}
