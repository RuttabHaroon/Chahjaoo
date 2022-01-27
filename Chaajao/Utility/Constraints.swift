//
//  Constraints.swift
//  ConstraintsSample
//
//  Created by Ahmed Khan on 2/14/17.
//  Copyright © 2017 TechSurge Inc. All rights reserved.
//

import UIKit

class Constraints: NSObject {
    
    class func leadingTrailingBottomTopToSuperView (subview : UIView,superView:UIView,constant:CGFloat,attriableValue:NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
   
        let leadingConstraints = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:.equal, toItem: superView, attribute:attriableValue, multiplier: 1.0, constant:constant)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(leadingConstraints)
        return leadingConstraints
    
    }
    
    class func leadingTrailingBottomTopToSuperView (subview : UIView,superView:UIView,constant:CGFloat,attriableValue:NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation) -> NSLayoutConstraint? {
     
          let leadingConstraints = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:relatedBy, toItem: superView, attribute:attriableValue, multiplier: 1.0, constant:constant)
          subview.translatesAutoresizingMaskIntoConstraints = false
          superView.addConstraint(leadingConstraints)
          return leadingConstraints
      
      }
      
    
    
    
    class func leadingTrailingBottomTopToSuperView (subview : UIView,superView:UIView,constraintTo:UIView,constant:CGFloat,attriableValue:NSLayoutConstraint.Attribute,attriableTo:NSLayoutConstraint.Attribute)-> NSLayoutConstraint? {
        
        let leadingConstraints = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:.equal, toItem: constraintTo, attribute:attriableTo, multiplier: 1.0, constant:constant)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(leadingConstraints)
        return leadingConstraints
        
    }
    
    
    class func centerXToSuperView(subview : UIView,superView:UIView) -> NSLayoutConstraint? {
        
        let centerXToSuperView = NSLayoutConstraint(item: subview, attribute:.centerX, relatedBy:.equal, toItem:superView, attribute:.centerX, multiplier: 1.0, constant:0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(centerXToSuperView)
        return centerXToSuperView
    }
    
    class func centerYToSuperView(subview : UIView,superView:UIView)-> NSLayoutConstraint? {
        
        let centerYToSuperView = NSLayoutConstraint(item: subview, attribute:.centerY, relatedBy:.equal, toItem:superView, attribute:.centerY, multiplier: 1.0, constant:0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(centerYToSuperView)
        return centerYToSuperView
    }
    
    class func equalWidthHeightToSuperView(subview :UIView,superView:UIView,equalViewTo:UIView,multiplier:CGFloat,
                                           attriableValue:NSLayoutConstraint.Attribute) -> NSLayoutConstraint?{
        let equalWidthHeightToSuperView = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:.equal, toItem:equalViewTo, attribute:attriableValue, multiplier:multiplier, constant:0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(equalWidthHeightToSuperView)
        return equalWidthHeightToSuperView
    }
    
    class func equalWidthHeightToSuperView(subview :UIView,superView:UIView,equalViewTo:UIView?,multiplier:CGFloat,
                                           attriableValue:NSLayoutConstraint.Attribute,attriableValueTo:NSLayoutConstraint.Attribute,constant:CGFloat)-> NSLayoutConstraint? {
        let equalWidthHeightToSuperView = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:.equal, toItem:equalViewTo, attribute:attriableValueTo, multiplier:multiplier, constant:constant)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(equalWidthHeightToSuperView)
         return equalWidthHeightToSuperView
    }
    class func equalWidthHeightToSuperView (subview :UIView,superView:UIView,multiplier:CGFloat,attriableValue:NSLayoutConstraint.Attribute)-> NSLayoutConstraint? {
        let equalWidthHeightToSuperView = NSLayoutConstraint(item: subview, attribute:attriableValue, relatedBy:.equal, toItem:superView, attribute:attriableValue, multiplier:multiplier, constant:0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(equalWidthHeightToSuperView)
         return equalWidthHeightToSuperView
    }
   
    
    
    class func fixedWidthHeightToSuperView (subview :UIView, superView:UIView,constant:CGFloat, attributeValue: NSLayoutConstraint.Attribute, toItemAttributeValue: NSLayoutConstraint.Attribute, constraintTo: UIView?) -> NSLayoutConstraint?{
        let fixedWidthHeightToSuperView = NSLayoutConstraint(item: subview, attribute:attributeValue, relatedBy:.equal, toItem: constraintTo, attribute:toItemAttributeValue, multiplier:1.0, constant: constant)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(fixedWidthHeightToSuperView)
         return fixedWidthHeightToSuperView
        }
}
