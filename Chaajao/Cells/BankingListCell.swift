//
//  BankingListCell.swift
//  CDC
//
//  Created by Ahmed Khan on 20/06/2020.
//  Copyright © 2020-21 TechSurge Inc. All rights reserved.
//

import UIKit

protocol BankingListCellDelegate: AnyObject {
	func updateList(cell: BankingListCell, newList: [CoursePickerModel])
	func forceRefreshed(cell: BankingListCell)
	func toggleTapped(cell: BankingListCell, isExpanded: Bool)
}

class BankingListCell: BaseUITableViewCell {
	@IBOutlet weak var header: BaseUIView!
	@IBOutlet weak var titleLabel: BaseUILabel!
	@IBOutlet weak var descriptionLabel: BaseUILabel!
	@IBOutlet weak var counterButton: BaseUIButton!
	@IBOutlet weak var expandButton: BaseUIButton!
	@IBOutlet weak var cellHeightConst: NSLayoutConstraint!
	@IBOutlet weak var collectionView: UICollectionView!
	var xDimension: CGFloat = 0
	var rowWidth: CGFloat = 0
	var collectionViewWidth: CGFloat = 0
	var size: CGFloat = 0
	var items = [CoursePickerModel]()
	var itemsInARow: Int = 3
	var delegate: BankingListCellDelegate?

	override func awakeFromNib() {
		super.awakeFromNib()
		addCollectionView()
		if UIApplication.shared.statusBarOrientation == .portrait {
			rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		} else {
			rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		}
		xDimension = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		collectionViewWidth = xDimension - 40
		size = (collectionViewWidth/3)
		itemsInARow = Int(floor(rowWidth / size))
		for view in header.subviews {
			view.isUserInteractionEnabled = true
			view.addTapGesture(tapNumber: 1, target: self, action: #selector(toggleView))
		}
		header.isUserInteractionEnabled = true
		header.addTapGesture(tapNumber: 1, target: self, action: #selector(toggleView))
		expandButton.addTapGesture(tapNumber: 1, target: self, action: #selector(toggleView))
	}

	
	@objc func toggleView() {
		if cellHeightConst.constant == 0 {
			if CGFloat(collectionView.numberOfItems(inSection: 0)) < CGFloat(itemsInARow) {
				cellHeightConst.constant = size
			} else {
				cellHeightConst.constant = size * ceil(CGFloat(collectionView.numberOfItems(inSection: 0)) / CGFloat(itemsInARow))
			}
		} else {
			cellHeightConst.constant = 0
		}
		self.layoutIfNeeded()
		if self.cellHeightConst.constant != 0 {
			self.delegate?.toggleTapped(cell: self ,isExpanded: true)
			self.expandButton.setImage(UIImage(named: "Minus.Black"), for: .normal)
		} else {
			self.delegate?.toggleTapped(cell: self ,isExpanded: false)
			self.expandButton.setImage(UIImage(named: "Add.Black"), for: .normal)
		}
	}

	func toggle(toggle: Bool) {
		if toggle {
			if CGFloat(collectionView.numberOfItems(inSection: 0)) < CGFloat(itemsInARow) {
				cellHeightConst.constant = size
			} else {
				cellHeightConst.constant = size * ceil(CGFloat(collectionView.numberOfItems(inSection: 0)) / CGFloat(itemsInARow))
			}
		} else {
			cellHeightConst.constant = 0
		}
		self.layoutIfNeeded()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	override func updateData(_ data: Any?) {
		super.updateData(data)
		if UIApplication.shared.statusBarOrientation == .portrait {
			rowWidth = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		} else {
			rowWidth = WINDOW_WIDTH > WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		}
		xDimension = WINDOW_WIDTH < WINDOW_HIEGHT ? WINDOW_WIDTH : WINDOW_HIEGHT
		collectionViewWidth = xDimension - 40
		size = (collectionViewWidth/3)
		itemsInARow = Int(floor(rowWidth / size))

		let dict = data as! [String:Any]

		let title = dict["title"] as? String ?? ""
		titleLabel.text = title

		let description = dict["description"] as? String ?? ""
		descriptionLabel.text = description

		let count = dict["count"] as? Int ?? 0
		counterButton.setTitle(String(count), for: .normal)
//		counterButton.isHidden = count == 0

		let isExpanded = dict["isExpanded"] as? Bool ?? false
		let forceRefresh = dict["forceRefresh"] as? Bool ?? false
		items = dict["items"] as? [CoursePickerModel] ?? [CoursePickerModel]()
		if isExpanded {
			if cellHeightConst.constant == 0 || forceRefresh {
				toggle(toggle: true)
			}
			expandButton.setImage(UIImage(named: "Minus.Black"), for: .normal)
		} else {
			if cellHeightConst.constant != 0 || forceRefresh {
				toggle(toggle: false)
			}
			expandButton.setImage(UIImage(named: "Add.Black"), for: .normal)
		}
		self.collectionView.reloadData()
	}

	func addCollectionView () {
		ExertUtility.addcollectionView(collectionView:collectionView, st:[BankCollectionCell.cellIdentifier])
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		self.collectionView?.collectionViewLayout = layout
	}
}

extension BankingListCell: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankCollectionCell.cellIdentifier, for: indexPath) as! BankCollectionCell
		cell.updateData(items[indexPath.row])
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return ExertUtility.isIPad ? CGSize(width: xDimension * 0.2 - 10, height: xDimension * 0.2 - 10) : CGSize(width: size, height: size)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}

extension BankingListCell : BankCollectionCellDelegate {

	func itemTapped(cell: BankCollectionCell) {
		if let index = collectionView.indexPath(for: cell) {
			for i in 0..<items.count {
				if i == index.row {
					items[i].isSelected = true
				} else {
					items[i].isSelected = false
				}
			}
			collectionView.reloadData()
			delegate?.updateList(cell: self, newList: items)
		}
	}
}
