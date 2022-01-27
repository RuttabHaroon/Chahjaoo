//
//  BookmarksListViewModel.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/10/2021.
//

import Foundation
import Alamofire
class BookmarksListViewModel {

	var items = [QuestionModel]()
	var count = 0 {
		didSet {
			self.itemsUpdated()
		}
	}
	var itemsUpdated:()->Void = {}

	func getData() {
		items.removeAll()
		let answers = [
            AnswerModel(answerID: 0, text: "1", reason: "Solution:\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tincidunt, ex vel interdum blandit, lorem felis feugiat elit, in iaculis dui est vel lectus. Proin convallis at ex aliquam commodo.", imageLink: "", isCorrect: true, shouldExpand: true, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
            AnswerModel(answerID: 0, text: "3", reason: "", imageLink: "", isCorrect: false, shouldExpand: false, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
            AnswerModel(answerID: 0, text: "7", reason: "", imageLink: "", isCorrect: false, shouldExpand: false, isSelected: false, questionID: 0, questionDiffcultyLevel: ""),
            AnswerModel(answerID: 0, text: "9", reason: "", imageLink: "", isCorrect: false, shouldExpand: false, isSelected: false, questionID: 0, questionDiffcultyLevel: "")]
		let question = "Find the number of terms of the given sequence 32,24, 16, 8.. for which the sum of the terms is Zero."
		for _ in 0..<5 {
            items.append(QuestionModel(questionID: 0, text: question, img: nil, category: "Topical Test - Math - Chapter 1", answers: answers, isBookmarked: true, timeTaken: 0, questionType: 0, questionAnswerTyped: "", questionDiffcultyLevel: ""))
		}
		count = items.count
	}
}
