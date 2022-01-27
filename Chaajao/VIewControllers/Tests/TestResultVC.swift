//
//  TestResultVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 11/10/2021.
//

import Foundation
import UIKit

class TestResultVC : BaseCustomController {


	@IBOutlet var starLeftBottom: UIView!
	@IBOutlet var starRightBottom: UIView!
	@IBOutlet var starMiddle: UIView!
	@IBOutlet var starLeftTop: UIView!
	@IBOutlet var starRightTop: UIView!
	@IBOutlet var starRightBottomIV: UIImageView!
	@IBOutlet var starLeftBottomIV: UIImageView!
	@IBOutlet var starMiddleIV: UIImageView!
	@IBOutlet var starLeftTopIV: UIImageView!
	@IBOutlet var starRightTopIV: UIImageView!

	@IBOutlet var resultLabel: UILabel!

    var quizResultData : [String: Any] = [:]
    var testDetailData: TestDetail?
    
	var angle:CGFloat = 24.0

	let starBlank = UIImage(named: "Star.Blank.1")!
	let starFilled = UIImage(named: "Star.Filled.1")!
	var resRand = result.best

	override func viewDidLoad() {
		super.viewDidLoad()
		resultLabel.text = resRand.rawValue
		rotateStars()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setResult()
	}

	func setResult() {
		print(resRand.rawValue)
		switch resRand {
			case .best:
				setStar(imageView: starRightTopIV, image: starFilled)
				setStar(imageView: starMiddleIV, image: starFilled)
				setStar(imageView: starLeftTopIV, image: starFilled)

				setStar(imageView: starRightBottomIV, image: starFilled, _delay: 0.3)
				setStar(imageView: starLeftBottomIV, image: starFilled, _delay: 0.3)
			case .ok:
				setStar(imageView: starRightBottomIV, image: starBlank)
				setStar(imageView: starRightTopIV, image: starFilled)
				setStar(imageView: starMiddleIV, image: starFilled)
				setStar(imageView: starLeftTopIV, image: starFilled)
				setStar(imageView: starLeftBottomIV, image: starBlank)
			case .worst:
				setStar(imageView: starRightBottomIV, image: starBlank)
				setStar(imageView: starRightTopIV, image: starBlank)
				setStar(imageView: starMiddleIV, image: starBlank)
				setStar(imageView: starLeftTopIV, image: starBlank)
				setStar(imageView: starLeftBottomIV, image: starBlank)
		}
	}

	func setStar(imageView: UIImageView, image: UIImage, _delay: Double = 0) {
		delay(_delay, closure: {
			let fadeAnim:CABasicAnimation = CABasicAnimation(keyPath: "contents")

			fadeAnim.fromValue = imageView.image
			fadeAnim.toValue   = image
			fadeAnim.duration  = 0.3;

			imageView.layer.add(fadeAnim, forKey: "contents")
			imageView.image = image
		})
	}

	func rotateStars() {
		starLeftBottom.rotation = -60
		starRightBottom.rotation = 60
		starLeftTop.rotation = -30
		starRightTop.rotation = 30
	}

	@IBAction func goToAnalytics() {
		navToResultsVc()
	}

	func navToResultsVc() {
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		APP_DELEGATE.navController.popToRootViewController(animated: false)
		let resultsVc = PracticeZoneResultVC.instantiate(fromAppStoryboard: .practiceZone)
        resultsVc.quizResultData = self.quizResultData
        resultsVc.testDetailData = self.testDetailData
		APP_DELEGATE.navController.pushViewController(resultsVc, animated: true)
	}
}
