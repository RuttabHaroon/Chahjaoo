//
//  AskYourDoubtVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 15/09/2021.
//

import UIKit

class AskYourDoubtVC : BaseCustomController {

//	var currentStep = 1
	@IBOutlet weak var initialView: UIView!
	@IBOutlet weak var successView: UIView!
	@IBOutlet weak var nextButton: BaseUIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var selectSubjectView: BaseUIView!
	@IBOutlet weak var enterDetailsView: BaseUIView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
	var xDimension: CGFloat = 0
	var rowWidth: CGFloat = 0
	var collectionViewWidth: CGFloat = 0
	var size: CGFloat = 0
	var items = [SubjectPickerModel]()
	var itemsInARow: Int = 4

	override func viewDidLoad() {
		super.viewDidLoad()
		if UIApplication.shared.statusBarOrientation == .portrait {
			rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		} else {
			rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		}
		xDimension = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		collectionViewWidth = xDimension - 40
		size = (collectionViewWidth/4)
		itemsInARow = Int(floor(rowWidth / size))
		items.append(SubjectPickerModel.init(name: "Maths", iconName: "Streaming", isSelected: false))
		items.append(SubjectPickerModel.init(name: "Physics", iconName: "Streaming", isSelected: false))
		items.append(SubjectPickerModel.init(name: "Chemistry", iconName: "Streaming", isSelected: false))
		items.append(SubjectPickerModel.init(name: "English", iconName: "Streaming", isSelected: false))
		items.append(SubjectPickerModel.init(name: "IQ", iconName: "Streaming", isSelected: false))
		items.append(SubjectPickerModel.init(name: "Other", iconName: "Streaming", isSelected: false))
		addCollectionView()
	}

	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)
		DispatchQueue.main.async(execute: {
			delay(0.1, closure: {
				if UIApplication.shared.statusBarOrientation == .portrait {
					self.rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
				} else {
					self.rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
				}
				self.xDimension = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
				self.collectionViewWidth = self.xDimension - 40
				self.size = (self.collectionViewWidth/4)
				self.itemsInARow = Int(floor(self.rowWidth / self.size))
				if CGFloat(self.collectionView.numberOfItems(inSection: 0)) < CGFloat(self.itemsInARow) {
					self.collectionViewHeightConstraint.constant = (self.size  * 1.5)
				} else {
					self.collectionViewHeightConstraint.constant = (self.size  * 1.5) * ceil(CGFloat(self.collectionView.numberOfItems(inSection: 0)) / CGFloat(self.itemsInARow))
				}
				self.collectionView.reloadData()
				self.view.layoutIfNeeded()
			})
		})
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if CGFloat(collectionView.numberOfItems(inSection: 0)) < CGFloat(itemsInARow) {
			collectionViewHeightConstraint.constant = (size  * 1.5)
		} else {
			collectionViewHeightConstraint.constant = (size  * 1.5) * ceil(CGFloat(collectionView.numberOfItems(inSection: 0)) / CGFloat(itemsInARow))
		}
	}

	func addCollectionView() {
		ExertUtility.addcollectionView(collectionView:collectionView, st:[SubjectCell.cellIdentifier])
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		collectionView.isScrollEnabled = false
		collectionView?.collectionViewLayout = layout
	}
}

//MARK: IBActions
extension AskYourDoubtVC {
	@IBAction func back() {
		if selectSubjectView.isHidden {
			UIView.animate(withDuration: 0.3, animations: {
				self.selectSubjectView.alpha = 1
				self.enterDetailsView.alpha = 0
			}, completion: {_ in
				self.nextButton.setTitle("NEXT", for: .normal)
				self.scrollView.scrollToTop(animated: false)
				self.selectSubjectView.isHidden = false
				self.enterDetailsView.isHidden = true
			})
		} else {
			backButtonTapped()
		}
	}

	@IBAction func backToMainScreen() {
		APP_DELEGATE.navController.popToRootViewController(animated: true)
	}

	@IBAction func close() {
		backButtonTapped()
	}

	@IBAction func next() {
		if enterDetailsView.isHidden {
			UIView.animate(withDuration: 0.3, animations: {
				self.selectSubjectView.alpha = 0
				self.enterDetailsView.alpha = 1
			}, completion: {_ in
				self.scrollView.scrollToTop(animated: false)
				self.nextButton.setTitle("SUBMIT", for: .normal)
				self.selectSubjectView.isHidden = true
				self.enterDetailsView.isHidden = false
			})
		} else {
			showSuccessView()
		}
	}
}

//MARK: Navigation
extension AskYourDoubtVC {
	func showSuccessView() {
		UIView.animate(withDuration: 0.3, animations: {
			self.initialView.alpha = 0
			self.successView.alpha = 1
		}, completion: {_ in
			self.initialView.isHidden = true
			self.successView.isHidden = false
		})
	}
}

//MARK: UICollectionViewDelegate
extension AskYourDoubtVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubjectCell.cellIdentifier, for: indexPath) as! SubjectCell
		cell.updateData(items[indexPath.row])
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return ExertUtility.isIPad ? CGSize(width: xDimension * 0.2 - 10, height: (xDimension * 0.2 - 10) * 1.5) : CGSize(width: size, height: size * 1.5 )
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}

//extension SubjectCellDelegate
extension AskYourDoubtVC : SubjectCellDelegate {

	func itemTapped(cell: SubjectCell) {
		if let index = collectionView.indexPath(for: cell) {
			for i in 0..<items.count {
				if i == index.row {
					items[i].isSelected = true
				} else {
					items[i].isSelected = false
				}
			}
			collectionView.reloadData()
		}
	}
}
