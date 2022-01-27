//
//  AHTagView.swift
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-09-21.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

import UIKit

@objc protocol AHTagViewDelegate: class {
    
    @objc optional  func deleteTag (aHTagView: AHTagView)
    
}


@objc(AHTagView)
class AHTagView: UIView {
    
    var widtConstraint: NSLayoutConstraint?
    weak var delegate: AHTagViewDelegate?
    var aHTag: AHTag?
    lazy var label = { () -> UILabel in
        let label = UILabel()
        label.textColor = UIColor(named: "#999999")
       label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.masksToBounds = true
        return label
    }()
    
     var containerView = { () -> UIView in
          let view = UIView()
          view.layer.borderWidth = 1
          view.layer.borderColor = UIColor(named: "border-color")?.cgColor
          view.layer.cornerRadius = 15
          view.isUserInteractionEnabled = true
          view.translatesAutoresizingMaskIntoConstraints = false
         // view.layer.masksToBounds = true
          return view
      }()
    
    
    lazy var buttton = { () -> UIButton in
        let button = UIButton()
        button.setImage(UIImage(named: "symcross-icon"), for: .normal)
        button.isHidden = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(crossActionClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        
        //self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @objc func crossActionClicked(sender: Any) {
        delegate?.deleteTag?(aHTagView: self)
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor.white
        self.containerView.addSubview(self.label)
        self.containerView.addSubview(self.buttton)
        self.addSubview(containerView)
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
       
      let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self.containerView, superView: self, constant: 5, attriableValue: .leading)
        
      let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self.containerView, superView: self, constant: -5, attriableValue: .trailing)
        
      let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self.containerView, superView: self, constant: 5, attriableValue: .top)
        
      let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: self.containerView, superView: self, constant: -5, attriableValue: .bottom)
        
        
        
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-4.0-[label]-4.0-[buttton]",
                                                                      options: .directionLeadingToTrailing,
                                                                      metrics: nil,
                                                                      views: ["label" : self.label, "buttton" : self.buttton]))
        
        
//        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[label]-6.0-[buttton]",
//                                                                             metrics: nil,
//                                                                             views: ["label" : self.label,"buttton" : self.buttton]))
        
       constraints.append(NSLayoutConstraint(item: self.label,
                                              attribute: .height,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: 30))
        constraints.append(NSLayoutConstraint(item: self.label,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self.containerView,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 3))
        constraints.append(NSLayoutConstraint(item: self.containerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self.label,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 3))
        
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[buttton]-1.0-|",
                                                                           metrics: nil,
                                                                           views: ["buttton" : self.buttton]))
        constraints.append(NSLayoutConstraint(item: self.buttton,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .height,
                                                   multiplier: 1,
                                                   constant: 20))
widtConstraint = NSLayoutConstraint(item: self.buttton,
attribute: .width,
relatedBy: .equal,
toItem: nil,
attribute: .width,
multiplier: 1,

constant: 20)
        constraints.append(widtConstraint!)

        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[buttton]",
                                                                      options: .alignAllCenterY,
                                                                              metrics: nil,
                                                                              views: ["superview":self.containerView,"buttton" : self.buttton]))
        
        NSLayoutConstraint.activate(constraints)
    }
    

    open func image() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}
