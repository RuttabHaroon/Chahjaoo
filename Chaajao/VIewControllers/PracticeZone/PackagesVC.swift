//
//  PackagesVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 21/09/2021.
//

import Foundation

class PackagesVC : BaseCustomController {
	@IBOutlet weak var step1ScrollView: UIScrollView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var stackViewHeight: NSLayoutConstraint!
	@IBOutlet weak var stackViewWidth: NSLayoutConstraint!
	var itemWidth : CGFloat = 0
	var items = [PackageModel]()

	override func viewDidLoad() {
		super.viewDidLoad()
		initTestModels()
		initViews()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		step1ScrollView.flashScrollIndicators()
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		delay(0, closure: {
			self.initViews()
		})
	}

	func initTestModels() {
		items.removeAll()
		items.append(PackageModel(name: "Chaajao Ultimate", price: "Rs. 10,000", features: ["Live Lectures", "Class Notes", "Practice Zone (Basic)", "Past Papers"], selected: true))
		items.append(PackageModel(name: "Chaajao Advanced", price: "Rs. 15,000", features: ["Live Lectures", "Class Notes", "Practice Zone (Advanced)", "Past Papers", "Ask Your Doubts"], selected: false))
		items.append(PackageModel(name: "Chaajao Supreme", price: "Rs. 25,000", features: ["Live Lectures", "Class Notes", "Practice Zone (Supreme)", "Past Papers", "Ask Your Doubts", "Other stuff lol"], selected: false))
	}
	func initViews() {
		stackView.removeAllSubviews()
		var rowWidth : CGFloat = 0
		if UIDevice.current.orientation == .portrait {
			rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		} else {
			rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		}

		//Leading & Trailing Space
		rowWidth -= 20
		var width : CGFloat = 0
		var size = CGSize()
		if ExertUtility.isIPad {
			if UIDevice.current.orientation == .portrait {
				size = CGSize(width: rowWidth/3, height: 432)
			} else if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) {
				let x = [UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0, UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0]
				let y = [UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0, UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0]

				rowWidth -= x.max() ?? 0
				rowWidth -= y.max() ?? 0
				size = CGSize(width: rowWidth/4, height: 432)
			}
		} else {
			if UIDevice.current.orientation == .portrait {
				size = CGSize(width: rowWidth/2, height: 432)
			} else if [UIDeviceOrientation.landscapeLeft, UIDeviceOrientation.landscapeRight].contains(UIDevice.current.orientation) {
				let x = [UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0, UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0]
				let y = [UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0, UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0]

				rowWidth -= x.max() ?? 0
				rowWidth -= y.max() ?? 0
				size = CGSize(width: rowWidth/3, height: 432)
			}
		}
		itemWidth = size.width
		for item in items {
			let package  = PackageCollectionViewCell.loadNib()
			(package as! PackageCollectionViewCell).updateData(item)
			(package as! PackageCollectionViewCell).setSize(new: size)
			(package as! PackageCollectionViewCell).delegate = self
			width += (package as! PackageCollectionViewCell).frame.width
			stackView.addArrangedSubview(package)
		}
		stackViewWidth.constant = width
		stackViewHeight.constant = 432
		self.view.layoutIfNeeded()
	}
	
	@IBAction func scrollNext() {
		let offset = step1ScrollView.contentOffset
		let newOffset = (offset.x + itemWidth)
		if newOffset < (stackView.frame.width - itemWidth) {
			step1ScrollView.setContentOffset(CGPoint(x: newOffset, y: offset.y), animated: true)
		}
	}

	@IBAction func scrollPrevious() {
		let offset = step1ScrollView.contentOffset
		let newOffset = (offset.x - itemWidth)
		if newOffset >= 0 {
			step1ScrollView.setContentOffset(CGPoint(x: newOffset, y: offset.y), animated: true)
		}
	}
}

//MARK: PackageCollectionViewCellDelegate
extension PackagesVC : PackageCollectionViewCellDelegate {
	func selected(cell: PackageCollectionViewCell) {
		for i in 0..<items.count {
			if items[i].name == cell.model.name {
				items[i].selected = true
			} else {
				items[i].selected = false
			}
			if let cell = stackView.arrangedSubviews[i] as? PackageCollectionViewCell {
				cell.updateBtn(items[i])
			}
		}
	}
}
