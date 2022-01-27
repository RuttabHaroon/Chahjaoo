//
//  PracticeZoneResultVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 27/09/2021.
//

import Foundation
import Charts
import UIKit

class PracticeZoneResultVC : BaseCustomController {
	@IBOutlet var cornerViewTopMarginConstraint: NSLayoutConstraint!
	@IBOutlet var cornerViewTrailingMarginConstraint: NSLayoutConstraint!

	@IBOutlet var scoreAndStatsCircularProgressBar: [CircularProgressBar]!
    @IBOutlet weak var correctCircularProgressBar: CircularProgressBar!
    @IBOutlet weak var incorrectCircularProgressBar: CircularProgressBar!
    @IBOutlet weak var skipCircularProgressBar: CircularProgressBar!
    @IBOutlet var statsDescriptionView: BaseUIView!
	@IBOutlet var performanceAnalysisBarChartView: BarChartView!
	@IBOutlet var timeTakenForEachQuestionBarChartView: BarChartView!
	@IBOutlet var accuracyCircularProgressBar : CircularProgressBar!
	
    
    @IBOutlet weak var unansweredQuestionCountLabel: UILabel!
    @IBOutlet weak var bookmarkedQuestionLabelCount: UILabel!
    @IBOutlet weak var questionAttemptedCount: UILabel!
    @IBOutlet weak var questionCorrectCountLabel: UILabel!
    
    
	let groups = ["Easy", "Medium", "Hard"]
    var correct : [Int] = [] //[10, 25, 30]
    var incorrect : [Int]  = [] //[40, 20, 60]
	var skipped : [Int]  = [] //[20, 45, 10]
	var timeTakenForQuestions : [Int]  =  [] //[30, 60, 40, 10, 20, 25, 45, 30, 10, 30, 20, 25, 40, 10, 55]

    var quizResultData : [String: Any] = [:] //this is the result of the quiz/test and is used as a param in submittest API
    var testDetailData: TestDetail? // this is test detail data coming from testdetail API
    var timeTakenToSolveQuiz = 0
    var questionAnsweredCorrectlyCount = 0
    var questionAnsweredIncorrectlyCount = 0
    var totalEasyCorrectAnswersCount = 0
    var totalMediumCorrectAnswersCount = 0
    var totalHardCorrectAnswersCount = 0
    var totalEasyIncorrectAnswersCount = 0
    var totalMediumIncorrectAnswersCount = 0
    var totalHardIncorrectAnswersCount = 0
    
  
    var totalSkippedEasyQuestion = 0
    var totalSkippedMediumQuestion = 0
    var totalSkippedHardQuestion = 0
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
 
        
        if let sectionList = quizResultData["sectionList"] as? [[String:Any]] {
            sectionList.forEach { section in
                
                if let totalTimeIttTookToFinishQuiz = section["totalTimeTaken"] as? Int {
                    self.timeTakenToSolveQuiz = totalTimeIttTookToFinishQuiz
                }
                
                if let questionList = section["questionList"] as? [[String:Any]] {
                    var bookmarkedCount = 0
                    var unansweredCount = 0
                    var answeredCount = 0
                    questionList.forEach { question in
                        
                        //getting per question time for per question graph
                        if let timeTaken = question["totalTimeTaken"] as? Int {
                            //self.timeTakenToSolveQuiz = timeTaken
                            self.timeTakenForQuestions.append(timeTaken)
                            
                        }
                        if let bookmarked = question["isBookmarked"] as? Bool {
                            if bookmarked == true {
                                bookmarkedCount += 1
                            }
                        }
                        if let answerList = question["answerList"] as? [[String:Any]] {
                            if answerList.isEmpty {
                                unansweredCount += 1
                                
                                if let qID = question["questionId"] as? Int {
                                    let eArray = testDetailData?.testSections?[0].testSectionQuestions?.filter({$0.questionID == qID && $0.difficultyLevel?.lowercased() == "easy"})
                                    totalSkippedEasyQuestion += eArray?.count ?? 0
                                    
                                    let mArray = testDetailData?.testSections?[0].testSectionQuestions?.filter({$0.questionID == qID && $0.difficultyLevel?.lowercased() == "medium"})
                                    totalSkippedMediumQuestion += mArray?.count ?? 0
                                    
                                    let hArray = testDetailData?.testSections?[0].testSectionQuestions?.filter({$0.questionID == qID && $0.difficultyLevel?.lowercased() == "hard"})
                                    totalSkippedHardQuestion += hArray?.count ?? 0
                                }
                            }
                            else {
                                answeredCount += 1
                            }
                            
                            answerList.forEach { answer in
                                if let id = answer["answerId"] as? Int{
                                    if let questions = testDetailData?.testSections?[0].testSectionQuestions {
                                        questions.forEach { q in
                                            
                                            let easyCorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == true && q.difficultyLevel?.lowercased() == "easy"})
                                            let mediumCorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == true && q.difficultyLevel?.lowercased() == "medium"})
                                            let hardCorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == true && q.difficultyLevel?.lowercased() == "hard"})
                                            
                                            
                                            let easyIncorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == false && q.difficultyLevel?.lowercased() == "easy"})
                                            let mediumIncorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == false && q.difficultyLevel?.lowercased() == "medium"})
                                            let hardIncorrectAnswersCount  = q.answers?.filter({$0.answerID == id && $0.isCorrect == false && q.difficultyLevel?.lowercased() == "hard"})
                                            
                                            totalEasyCorrectAnswersCount += easyCorrectAnswersCount?.count ?? 0
                                            totalMediumCorrectAnswersCount += mediumCorrectAnswersCount?.count ?? 0
                                            totalHardCorrectAnswersCount += hardCorrectAnswersCount?.count ?? 0
                                            
                                            totalEasyIncorrectAnswersCount += easyIncorrectAnswersCount?.count ?? 0
                                            totalMediumIncorrectAnswersCount += mediumIncorrectAnswersCount?.count ?? 0
                                            totalHardIncorrectAnswersCount += hardIncorrectAnswersCount?.count ?? 0
                                            
                                            
                                            let totalCorrectCount = (easyCorrectAnswersCount ?? []) + (mediumCorrectAnswersCount ?? []) + (hardCorrectAnswersCount ?? [])
                                            let totalInCorrectCount = (easyIncorrectAnswersCount ?? []) + (mediumIncorrectAnswersCount ?? []) + (hardIncorrectAnswersCount ?? [])
                                            
                                            
                                            questionAnsweredCorrectlyCount += totalCorrectCount.count
                                            questionAnsweredIncorrectlyCount += totalInCorrectCount.count
                                             
                                        }
                                    }
                                }
                            }
                        }
                    }
                    bookmarkedQuestionLabelCount.text = String(bookmarkedCount)
                    unansweredQuestionCountLabel.text = String(unansweredCount)
                    questionAttemptedCount.text = String(answeredCount)
                    questionCorrectCountLabel.text = String(questionAnsweredCorrectlyCount)
                }
            }
        }
        
        
    //score and stats graph
		for i in 0..<scoreAndStatsCircularProgressBar.count {
            if scoreAndStatsCircularProgressBar[i].accessibilityIdentifier! == "greenProgress" {
                scoreAndStatsCircularProgressBar[i].foregroundLayer.strokeColor = UIColor(red: 0.50, green: 0.84, blue: 0.29, alpha: 1.00).cgColor
                scoreAndStatsCircularProgressBar[i].value = String(self.questionAnsweredCorrectlyCount)
                var attempted = questionAnsweredCorrectlyCount + questionAnsweredIncorrectlyCount
                attempted = attempted <= 0 ? 1 : attempted
                let progress :Double = (Double(questionAnsweredCorrectlyCount)/Double(attempted))
                print("progress A : \(progress)")
                correctCircularProgressBar.progress = progress
            }
            else if scoreAndStatsCircularProgressBar[i].accessibilityIdentifier! == "pinkProgress" {
                scoreAndStatsCircularProgressBar[i].foregroundLayer.strokeColor = UIColor(red: 0.94, green: 0.74, blue: 0.20, alpha: 1.00).cgColor
                scoreAndStatsCircularProgressBar[i].value = String(self.questionAnsweredIncorrectlyCount)
                var attempted = questionAnsweredCorrectlyCount + questionAnsweredIncorrectlyCount
                attempted = attempted <= 0 ? 1 : attempted
                let progress :Double = (Double(questionAnsweredIncorrectlyCount)/Double(attempted))
                incorrectCircularProgressBar.progress = progress
            }
            else if scoreAndStatsCircularProgressBar[i].accessibilityIdentifier! == "mustardProgress" {
                scoreAndStatsCircularProgressBar[i].foregroundLayer.strokeColor = UIColor(red: 0.87, green: 0.42, blue: 0.53, alpha: 1.00).cgColor
                scoreAndStatsCircularProgressBar[i].value = String(self.timeTakenToSolveQuiz)
                let totalTimeForQuiz = self.testDetailData?.testSections?[0].totalTime ?? 0
                let progress : Double = (Double(timeTakenToSolveQuiz)/Double(totalTimeForQuiz))
                skipCircularProgressBar.progress = progress //progress
            }
		}

        
        //accurtacy ring graph
        accuracyCircularProgressBar.foregroundLayer.strokeColor = UIColor(named: accuracyCircularProgressBar.accessibilityIdentifier!)?.cgColor
        accuracyCircularProgressBar.topForegroundLayer.strokeColor = UIColor(named: "greenProgress")?.cgColor
        accuracyCircularProgressBar.hasTwoRings = true
        let attemptedIntValue = Int(questionAttemptedCount.text ?? "") ?? 0
        var total = attemptedIntValue + questionAnsweredCorrectlyCount
        if total > 0 {
            let p1 : Double = Double(attemptedIntValue)/Double(total)
            let p2 : Double = Double(questionAnsweredCorrectlyCount)/Double(total)
            accuracyCircularProgressBar.progress = p1
            accuracyCircularProgressBar.secondRingProgress = p2
            accuracyCircularProgressBar.value = String(total)
        }
        else {
            accuracyCircularProgressBar.progress = 0.0
            accuracyCircularProgressBar.secondRingProgress = 0.0
            accuracyCircularProgressBar.value = "0"
        }

		
        
        //pertformance anaylsis by diffculty chart
        self.correct = [totalEasyCorrectAnswersCount, totalMediumCorrectAnswersCount, totalHardIncorrectAnswersCount]
        self.incorrect = [totalEasyIncorrectAnswersCount, totalMediumIncorrectAnswersCount, totalHardIncorrectAnswersCount]
        self.skipped = [totalSkippedEasyQuestion, totalSkippedMediumQuestion, totalSkippedHardQuestion]
        
        
		statsDescriptionView.cornerRadius = statsDescriptionView.frame.height / 2
		statsDescriptionView.layer.cornerRadius = statsDescriptionView.cornerRadius
		setupPerformanceAnalysisChart()
		setupTimeTakenChart()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		var delay: Double = 0
		for ring in scoreAndStatsCircularProgressBar {
			animateProgress(progress: ring.progress, delayInS: delay, progressRing: ring)
			delay += 0.1
		}
		animateProgress(progress: 0.87, topProgress: 0.07, delayInS: delay, progressRing: accuracyCircularProgressBar)
	}

	func setupPerformanceAnalysisChart() {
		performanceAnalysisBarChartView.delegate = self
		performanceAnalysisBarChartView.noDataText = "Data unavailable."
		let legend = performanceAnalysisBarChartView.legend
		legend.enabled = false

		let xaxis = performanceAnalysisBarChartView.xAxis
		xaxis.drawGridLinesEnabled = false
		xaxis.labelPosition = .bottom
		xaxis.centerAxisLabelsEnabled = true
		xaxis.valueFormatter = IndexAxisValueFormatter(values:self.groups)
		xaxis.granularity = 1
		xaxis.labelFont = UIFont(name: EXERT_GLOBAL.fontName, size: 8)!
		xaxis.drawAxisLineEnabled = false

		let leftAxisFormatter = NumberFormatter()
		leftAxisFormatter.maximumFractionDigits = 1


		let yaxis = performanceAnalysisBarChartView.leftAxis
		yaxis.spaceTop = 0.35
		yaxis.axisMinimum = 0
		yaxis.axisMaximum = 100
		yaxis.labelFont = UIFont(name: EXERT_GLOBAL.fontName, size: 8)!
		yaxis.drawGridLinesEnabled = true

		yaxis.gridColor = UIColor(named: "lightestGray")!
		performanceAnalysisBarChartView.rightAxis.enabled = false
		yaxis.drawAxisLineEnabled = false
		yaxis.granularity = yaxis.axisMaximum/2

		performanceAnalysisBarChartView.noDataText = "No data available."
		performanceAnalysisBarChartView.drawValueAboveBarEnabled = false

		var dataEntries: [BarChartDataEntry] = []
		var dataEntries1: [BarChartDataEntry] = []
		var dataEntries2: [BarChartDataEntry] = []

		for i in 0..<self.groups.count {

			let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(self.correct[i]))
			dataEntries.append(dataEntry)

			let dataEntry1 = BarChartDataEntry(x: Double(i) , y: Double(self.incorrect[i]))
			dataEntries1.append(dataEntry1)

			let dataEntry2 = BarChartDataEntry(x: Double(i) , y: Double(self.skipped[i]))
			dataEntries2.append(dataEntry2)
		}

		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Correct")
		let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Incorrect")
		let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "Skipped")

		chartDataSet.colors = [UIColor(named: "greenProgress")!]
		chartDataSet1.colors = [UIColor(named: "pinkProgress")!]
		chartDataSet2.colors = [UIColor(named: "mustardProgress")!]
		chartDataSet.drawValuesEnabled = false
		chartDataSet1.drawValuesEnabled = false
		chartDataSet2.drawValuesEnabled = false
		let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1, chartDataSet2]
		let chartData = BarChartData(dataSets: dataSets)
		//interval per "group" = Double(_dataSets.count) * (self.barWidth + barSpace) + groupSpace
		//For iPhones: (0.2 + 0.05) * 3 + 0.25 = 1.00
		//For iPad: (0.075 + 0.1) * 3 + 0.475
		let groupSpace = ExertUtility.isIPad ? 0.475 : 0.25
		let barSpace = ExertUtility.isIPad ? 0.1 : 0.05
		let barWidth = ExertUtility.isIPad ? 0.075 : 0.2

		let groupCount = self.groups.count
		let startYear = 0

		chartData.barWidth = barWidth
		performanceAnalysisBarChartView.xAxis.axisMinimum = 0
		let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
		print("Groupspace: \(gg)")
		performanceAnalysisBarChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

		chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
		performanceAnalysisBarChartView.notifyDataSetChanged()
		performanceAnalysisBarChartView.data = chartData
		performanceAnalysisBarChartView.backgroundColor = .white
		performanceAnalysisBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 3, easingOption: .easeOutSine)
	}

	func setupTimeTakenChart() {
		timeTakenForEachQuestionBarChartView.delegate = self
		timeTakenForEachQuestionBarChartView.noDataText = "Data unavailable."
		let legend = timeTakenForEachQuestionBarChartView.legend
		legend.enabled = false

		let xaxis = timeTakenForEachQuestionBarChartView.xAxis
		xaxis.drawGridLinesEnabled = false
		xaxis.labelPosition = .bottom
		xaxis.centerAxisLabelsEnabled = false
		xaxis.drawAxisLineEnabled = false
		xaxis.valueFormatter = XAxisValueFormatter()
		xaxis.granularity = 1
		xaxis.labelFont = UIFont(name: EXERT_GLOBAL.fontName, size: 8)!
		xaxis.labelCount = timeTakenForQuestions.count


		let yaxis = timeTakenForEachQuestionBarChartView.leftAxis
		yaxis.spaceTop = 0.35
		yaxis.axisMinimum = 0
		yaxis.axisMaximum = Double(timeTakenForQuestions.max()!)
		yaxis.drawGridLinesEnabled = true
		yaxis.valueFormatter = YAxisValueFormatter()
		yaxis.gridColor = UIColor(named: "lightestGray")!
		yaxis.drawAxisLineEnabled = false
		yaxis.granularity = yaxis.axisMaximum/2
		yaxis.labelFont = UIFont(name: EXERT_GLOBAL.fontName, size: 8)!

		timeTakenForEachQuestionBarChartView.rightAxis.enabled = false
		timeTakenForEachQuestionBarChartView.noDataText = "No data available."
		timeTakenForEachQuestionBarChartView.drawValueAboveBarEnabled = false

		var dataEntries: [BarChartDataEntry] = []

		for i in 0..<self.timeTakenForQuestions.count {
			let dataEntry = BarChartDataEntry(x: Double(i) , y: Double(self.timeTakenForQuestions[i]))
			dataEntries.append(dataEntry)
		}

		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Questions")

		chartDataSet.colors = [UIColor(named: "greenProgress")!]
		chartDataSet.drawValuesEnabled = false
		let chartData = BarChartData(dataSet: chartDataSet)

		chartData.barWidth = ExertUtility.isIPad ? 0.35 : 0.4
		timeTakenForEachQuestionBarChartView.notifyDataSetChanged()
		timeTakenForEachQuestionBarChartView.data = chartData
		timeTakenForEachQuestionBarChartView.backgroundColor = .white
		timeTakenForEachQuestionBarChartView.animate(xAxisDuration: 1.5, yAxisDuration: 3, easingOption: .easeOutSine)
	}

	func animateProgress(progress: Double, delayInS: Double, progressRing: CircularProgressBar) {
		delay(delayInS, closure: {
			progressRing.setProgress(to: progress, withAnimation: true)
		})
	}
	func animateProgress(progress: Double, topProgress: Double, delayInS: Double, progressRing: CircularProgressBar) {
		delay(delayInS, closure: {
			progressRing.setProgress(to: progress, withAnimation: true, topProgressConstant: topProgress)
		})
	}

	
	@IBAction func back() {
		backButtonTapped()
	}

	@IBAction func viewSolutions() {
		let solutionsVc = SolutionsMainVC.instantiate(fromAppStoryboard: .tests)
		APP_DELEGATE.navController.pushViewController(solutionsVc, animated: true)
	}
}

extension PracticeZoneResultVC : ChartViewDelegate {

}
