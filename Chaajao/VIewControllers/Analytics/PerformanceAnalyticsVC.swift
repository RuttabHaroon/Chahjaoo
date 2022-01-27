//
//  PerformanceAnalyticsVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 28/09/2021.
//

import Foundation
import MKRingProgressView
import UIKit

class PerformanceAnalyticsVC : BaseCustomController {
	@IBOutlet var allSubjectRingChartBaseView: UIView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var specificSubjectRingChartBaseView: UIView!
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var allSubjectRingChartParentView: BaseUIView!
	@IBOutlet var specificSubjectRingChartParentView: BaseUIView!

	var subjectsRing = [RingProgressView]()
	var allSubjectsRing = [RingProgressView]()

	let allSubjectProgressArray = [0.55, 0.65, 0.5, 0.3]
	let subjectProgressArray = [0.4, 0.4, 0.2]
	var selectedItem = "All"
	let allSubsColors = [UIColor(named: "greenProgress")!, UIColor(named: "pinkProgress")!, UIColor(named: "blueGradientEnd")!, UIColor(named: "mustardProgress")!]

	let specificSubsColors = [UIColor(named: "greenProgress")!, UIColor(named: "mustardProgress")!, UIColor(named: "pinkProgress")!]

	var items = [AnalyticsSubjectPickerModel]()

	override func viewDidLoad() {
		super.viewDidLoad()

		allSubjectsRing = setupRingCharts(numberOfRings: 4, defaultParentView: allSubjectRingChartParentView, ringColors: allSubsColors)

		subjectsRing = setupRingCharts(numberOfRings: 3, defaultParentView: specificSubjectRingChartParentView, ringColors: specificSubsColors)

		addCollectionView()

		items.append(AnalyticsSubjectPickerModel.init(name: "All", iconName: "Streaming", isSelected: true))
		items.append(AnalyticsSubjectPickerModel.init(name: "Maths", iconName: "Streaming", isSelected: false))
		items.append(AnalyticsSubjectPickerModel.init(name: "Physics", iconName: "Streaming", isSelected: false))
		items.append(AnalyticsSubjectPickerModel.init(name: "Chemistry", iconName: "Streaming", isSelected: false))
		items.append(AnalyticsSubjectPickerModel.init(name: "English", iconName: "Streaming", isSelected: false))
		items.append(AnalyticsSubjectPickerModel.init(name: "IQ", iconName: "Streaming", isSelected: false))
	}

	func addCollectionView() {
		ExertUtility.addcollectionView(collectionView:collectionView, st:[AnalyticsSubjectCollectionViewCell.cellIdentifier])
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		collectionView.isScrollEnabled = true
		collectionView?.collectionViewLayout = layout
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		resetRings()
		reloadViews()
	}

	func resetRings() {
		let rings = selectedItem == "All" ? allSubjectsRing : subjectsRing
		for i in 0..<rings.count {
			rings[i].progress = 0.0
			rings[i].layoutIfNeeded()
		}
	}

	func reloadViews() {
	let rings = selectedItem == "All" ? allSubjectsRing : subjectsRing
		delay(0, closure: {
			self.animateRings(rings: rings)
		})
	}

	func animateRings(rings: [RingProgressView]) {
		for i in 0..<rings.count {
			UIView.animate(withDuration: 2, animations: {
				rings[i].progress = self.selectedItem == "All" ? self.allSubjectProgressArray[i] : self.subjectProgressArray[i]
			})
		}
	}

	func firstTransition() {
		UIView.animate(withDuration: 0.15, animations: {
			if self.selectedItem == "All" {
				self.specificSubjectRingChartBaseView.alpha = 0
			} else {
				self.allSubjectRingChartBaseView.alpha = 0
			}
		}, completion: {_ in
			if self.selectedItem == "All" {
				self.specificSubjectRingChartBaseView.isHidden = true
			} else {
				self.allSubjectRingChartBaseView.isHidden = true
			}
			self.secondTransition()
		})
	}
	func secondTransition() {
		if self.selectedItem == "All" {
			self.allSubjectRingChartBaseView.isHidden = false
		} else {
			self.specificSubjectRingChartBaseView.isHidden = false
		}
		UIView.animate(withDuration: 0.15, animations: {
			if self.selectedItem == "All" {
				self.allSubjectRingChartBaseView.alpha = 1
			} else {
				self.specificSubjectRingChartBaseView.alpha = 1
			}
		}, completion: {_ in
			self.reloadViews()
		})
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	func setupRingCharts(numberOfRings: Int, defaultParentView: UIView, ringColors: [UIColor]) -> [RingProgressView] {

		var parentFrame = CGRect()
		var parentView = UIView()
		var padding = 0
		var rings = [RingProgressView]()
		for i in 0..<numberOfRings {
			if i == 0 {
				parentView = defaultParentView
				parentFrame = defaultParentView.frame
			} else {
				padding = 30
				parentView = rings[i - 1]
				parentFrame = rings[i - 1].frame
			}
			let ringFrame = CGRect(x: 0, y: 0, width: (parentFrame.width - CGFloat(padding)), height: (parentFrame.height - CGFloat(padding)))
			let nestedRing = RingProgressView(frame: ringFrame)
			parentView.addSubview(nestedRing)
			nestedRing.widthAnchor.constraint(equalTo: nestedRing.heightAnchor).isActive = true
			_ = Constraints.leadingTrailingBottomTopToSuperView(subview: nestedRing, superView: parentView, constant: 15, attriableValue: .top)
			_ = Constraints.leadingTrailingBottomTopToSuperView(subview: nestedRing, superView: parentView, constant: -15, attriableValue: .bottom)
			_ = Constraints.leadingTrailingBottomTopToSuperView(subview: nestedRing, superView: parentView, constant: 15, attriableValue: .leading)
			_ = Constraints.leadingTrailingBottomTopToSuperView(subview: nestedRing, superView: parentView, constant: -15, attriableValue: .trailing)
			nestedRing.backgroundColor = UIColor.clear
			nestedRing.backgroundRingColor = UIColor(named: "controllerBackground")
			nestedRing.startColor = ringColors[safe: i]!
			nestedRing.endColor = ringColors[safe: i]!
			nestedRing.allowsAntialiasing = true
			nestedRing.shadowOpacity = 0
			nestedRing.hidesRingForZeroProgress = false
			nestedRing.ringWidth = 7
			rings.append(nestedRing)
		}
		return rings
	}
}

//MARK: UICollectionViewDelegate
extension PerformanceAnalyticsVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnalyticsSubjectCollectionViewCell.cellIdentifier, for: indexPath) as! AnalyticsSubjectCollectionViewCell
		cell.updateData(items[indexPath.row])
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 70, height: 82.5)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}

//extension AnalyticsSubjectCollectionViewCellDelegate
extension PerformanceAnalyticsVC : AnalyticsSubjectCollectionViewCellDelegate {

	func itemTapped(cell: AnalyticsSubjectCollectionViewCell) {
		if let index = collectionView.indexPath(for: cell) {
			let lastSelectedItem = selectedItem
			selectedItem = items[index.row].name

			if index.row == 0 {
				titleLabel.text = "All Subjects"
			} else {
				titleLabel.text = items[index.row].name
			}
			for i in 0..<items.count {
				if i == index.row {
					items[i].isSelected = true
				} else {
					items[i].isSelected = false
				}
			}
			DispatchQueue.main.async(execute: {
				self.collectionView.reloadData()
			})
			if (lastSelectedItem == "All" && selectedItem != "All") || (lastSelectedItem != "All" && selectedItem == "All") || lastSelectedItem != selectedItem {
				resetRings()
			}
			firstTransition()
		}
	}
}
