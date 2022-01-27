//
//  AHTagsLabel.swift
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-09-21.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

import UIKit

struct AHTag {
    var title: String
    var Id:Int
    var symtomsId:Int
    var isshowCross:Bool = true
    var selected:Bool
    var isHidden:Bool
    init(dictionary: [String : Any]) {
        
        self.title = (dictionary["title"] as! String)
        
        self.Id = (dictionary["row"] as! Int)
        self.symtomsId = (dictionary["dataId"] as! Int)
        self.isshowCross = (dictionary["isshowCross"] as? Bool ?? true)
        self.selected = (dictionary["selected"] as? Bool ?? false)
        self.isHidden = (dictionary["isHidden"] as? Bool ?? false)
    }
    
    func attributedTitle() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        if #available(iOS 11.0, *) {
            paragraphStyle.headIndent = paragraphStyle.firstLineHeadIndent
            paragraphStyle.tailIndent = paragraphStyle.firstLineHeadIndent
        } else {
            paragraphStyle.firstLineHeadIndent = 10
            paragraphStyle.headIndent = 10
            paragraphStyle.tailIndent = 10
        }
        
        let attributes = [
            NSAttributedString.Key.paragraphStyle  : paragraphStyle,
            NSAttributedString.Key.font            : UIFont(name: "SegoeUI", size: ExertUtility.convertToRatio(11))

        ]
        
        
        return NSAttributedString(string: self.title, attributes: attributes as [NSAttributedString.Key : Any])
    }

}

@objc protocol AHTagsLabelDelegate: class {
    @objc optional  func rowSelected (row:Int, tagId: Int)
    
}

class AHTagsLabel: UILabel {
    var boundsArray = [CGRect]()
    var tags: [AHTag]?
    weak var delegate: AHTagsLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.setupGesture()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private func setup() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .left
        
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
    }
    
    private func setupGesture() {
       let recognizer = UITapGestureRecognizer(target: self, action: #selector(AHTagsLabel.tap(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc private func tap(recognizer: UITapGestureRecognizer) {
        guard let label = recognizer.view as? UILabel else {
            return
        }
        let container = NSTextContainer(size: label.frame.size)
        container.lineFragmentPadding = 0.0
        container.lineBreakMode = label.lineBreakMode
        container.maximumNumberOfLines = label.numberOfLines
        
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        
        guard let attributedText = label.attributedText else {
            return
        }
        let storage = NSTextStorage(attributedString: attributedText)
        storage.addLayoutManager(manager)
        
        let touchPoint = recognizer.location(in: label)
        let indexOfCharacter = manager.characterIndex(for: touchPoint,
                                                      in: container,
                                                      fractionOfDistanceBetweenInsertionPoints: nil)
        guard let tags = self.tags, tags.count > 0 else {
            return
        }
        var tag = tags[indexOfCharacter]
        for i in 0..<tags.count {
            if tag.Id == tags[i].Id {
                tag.selected = true
            } else {
                tag.selected = false
            }
        }
        if !tag.isHidden {
            delegate?.rowSelected?(row: tag.Id ,tagId: tag.symtomsId)
        }
    }
    
    open func setTags(_ tags: [AHTag]) {
        self.tags = tags

        let mutableString = NSMutableAttributedString()
        let cell = UITableViewCell()
       // cell.contentView.isUserInteractionEnabled = true
       // cell.isUserInteractionEnabled = true
        for (_, tag) in tags.enumerated() {
            let view = AHTagView()
            cell.selectionStyle = .default
        
            view.aHTag = tag
            view.widtConstraint?.constant = ( tag.isshowCross == true ) ? 20 : 0
            view.buttton.isHidden = !(tag.isshowCross)
            view.label.attributedText = tag.attributedTitle()
            view.containerView.backgroundColor = tag.selected ? UIColor("#0288D1") : .white
            view.containerView.isHidden = tag.isHidden
            view.containerView.isUserInteractionEnabled = !tag.isHidden
            view.label.textColor = tag.selected ? .white : UIColor("#999999")
            let size = view.systemLayoutSizeFitting(view.frame.size,
                                                    withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel,
                                                    verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            view.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
            cell.contentView.addSubview(view)
            cell.contentView.isUserInteractionEnabled = true
            cell.isUserInteractionEnabled =  true
            boundsArray.append(cell.bounds)
            let image = view.image()
            let attachment = NSTextAttachment()
            attachment.image = image

            let attrString = NSAttributedString(attachment: attachment)
            mutableString.beginEditing()
            mutableString.append(attrString)
            mutableString.endEditing()
        }
        
        self.attributedText = mutableString
    }
    
}
