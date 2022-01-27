//
//  UIGestureRecognizerExtension.swift
//  Chaajao
//
//  Created by Ahmed Khan on 12/08/2021.
//  Copyright © 2021 TechSurge Inc. All rights reserved.
//

import Foundation
extension UITapGestureRecognizer {

	func didTapAttributedTextInLabel(label: BaseUILabel, inRange targetRange: NSRange) -> Bool {
		// Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
		let layoutManager = NSLayoutManager()
		let textContainer = NSTextContainer(size: CGSize.zero)
		let textStorage = NSTextStorage(attributedString: label.attributedText!)

		// Configure layoutManager and textStorage
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)

		// Configure textContainer
		textContainer.lineFragmentPadding = 0.0
		textContainer.lineBreakMode = label.lineBreakMode
		textContainer.maximumNumberOfLines = label.numberOfLines
		let labelSize = label.bounds.size
		textContainer.size = labelSize

		// Find the tapped character location and compare it to the specified range
		let locationOfTouchInLabel = self.location(in: label)
		let textBoundingBox = layoutManager.usedRect(for: textContainer)
		let textContainerOffset = CGPoint(
			x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
			y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
		)
		let locationOfTouchInTextContainer = CGPoint(
			x: locationOfTouchInLabel.x - textContainerOffset.x,
			y: locationOfTouchInLabel.y - textContainerOffset.y
		)
		let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

		return NSLocationInRange(indexOfCharacter, targetRange)
	}

}

extension Range where Bound == String.Index {
	var nsRange:NSRange {
		return NSRange(location: self.lowerBound.encodedOffset,
					   length: self.upperBound.encodedOffset -
						self.lowerBound.encodedOffset)
	}
}
