//
//  AnswerView.swift
//  Chaajao
//
//  Created by Ahmed Khan on 24/09/2021.
//

import UIKit
import Kingfisher
import SVLatexView


@objc protocol AnswerViewDelegate: AnyObject {
	@objc func itemTapped(view: AnswerView)
}

class AnswerView: BaseUITableViewCell {

	@IBOutlet weak var idLabel: BaseUIButton!
	@IBOutlet weak var indicatorBtn: BaseUIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var explanationLabel: UILabel!
	@IBOutlet weak var baseView: BaseUIView!
	@IBOutlet weak var expTopAnchor: NSLayoutConstraint!
	@IBOutlet weak var expBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var containerView: BaseUIView!
    @IBOutlet weak var overButton: UIButton!
    
    var model: AnswerModel!
	var delegate: AnswerViewDelegate?
	var isViewingAsBookmark = false
	var isViewingAsSolution = false
    
    lazy var latexView: SVLatexView = {
        let v = SVLatexView(frame: CGRect.zero, using: SVLatexView.Engine.KaTeX, contentWidth: 200)
        //v.backgroundColor = .
        v.translatesAutoresizingMaskIntoConstraints = false
        v.customCSS = ".formula-wrap {line-height: 16px;}"
        //v.isHidden = true
        return v
    }()
    
    
	override func awakeFromNib() {
		super.awakeFromNib()
        self.containerView.addSubview(latexView)
        //self.containerView.insertSubview(latexView, belowSubview: overButton)
        self.sendSubviewToBack(latexView)
        NSLayoutConstraint(item: latexView, attribute: .leading, relatedBy: .equal, toItem: idLabel, attribute: .leading, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: latexView, attribute: .trailing, relatedBy: .equal, toItem: indicatorBtn, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: latexView, attribute: .top, relatedBy: .equal, toItem: idLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: latexView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: latexView, attribute: .centerY, relatedBy: .equal, toItem: idLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        self.latexView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped))
        self.latexView.addGestureRecognizer(tap)
	}

	@IBAction func itemTapped() {
		if !isViewingAsBookmark && !isViewingAsSolution {
			idLabel.setBackgroundImage(UIImage(named: "Question.Option.Selected"), for: .normal)
			delegate?.itemTapped(view: self)
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = ""
        latexView.loadLatexString(latexString: "")
		explanationLabel.text = ""
		indicatorBtn.isHidden = true
		explanationLabel.isHidden = true
		expTopAnchor.constant = 0
		expBottomAnchor.constant = 0
		idLabel.setBackgroundImage(UIImage(named: "Question.Option"), for: .normal)
		idLabel.setTitle("A", for: .normal)
	}

	override func updateData(_ data: Any?) {
		let dict = data as! [String:Any]
		let id = (dict["id"] as? Int ?? 0) + 64
		let option = String(UnicodeScalar(UInt8(id)))
		model = dict["model"] as? AnswerModel
		isViewingAsBookmark = dict["isViewingAsBookmark"] as? Bool ?? false
		isViewingAsSolution = dict["isViewingAsSolution"] as? Bool ?? false

		titleLabel.text = model.text
        latexView.loadLatexString(latexString: model.text)
		if model.shouldExpand {
			indicatorBtn.setImage(UIImage(named: model.isCorrect ? Answer.correct.rawValue : Answer.wrong.rawValue), for: .normal)
			indicatorBtn.isHidden = false
			baseView.borderColor = model.isCorrect ? UIColor(named: "greenBorder") : UIColor(named: "midRed")
			if model.reason != "" {
				explanationLabel.text = model.reason
				explanationLabel.isHidden = false
				expTopAnchor.constant = 5
				expBottomAnchor.constant = 10
			}
		}
		if model.isSelected {
			idLabel.setBackgroundImage(UIImage(named: "Question.Option.Selected"), for: .normal)
			idLabel.setTitleColor(.white, for: .normal)
		} else {
			idLabel.setBackgroundImage(UIImage(named: "Question.Option"), for: .normal)
			idLabel.setTitleColor(UIColor(named:"darkGray"), for: .normal)
		}
		idLabel.setTitle(option, for: .normal)
        
        if let url = URL(string: model.imageLink) {
            answerImageView.kf.setImage(with: url)
            answerImageView.isHidden = false
            latexView.isHidden = !answerImageView.isHidden
        }
        else {
            answerImageView.isHidden = true
            latexView.isHidden = !answerImageView.isHidden
        }
	}
}
