import UIKit

extension UIView {
	func fitInSuperView(parentView: UIView) {
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: parentView, constant: 0, attriableValue: .top)
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: parentView, constant: 0, attriableValue: .bottom)
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: parentView, constant: 0, attriableValue: .leading)
		_ = Constraints.leadingTrailingBottomTopToSuperView(subview: self, superView: parentView, constant: 0, attriableValue: .trailing)
	}
  func constrainToEdges(_ subview: UIView) {
    
    subview.translatesAutoresizingMaskIntoConstraints = false
    
    let topContraint = NSLayoutConstraint(
      item: subview,
      attribute: .top,
      relatedBy: .equal,
      toItem: self,
      attribute: .top,
      multiplier: 1.0,
      constant: 0)
    
    let bottomConstraint = NSLayoutConstraint(
      item: subview,
      attribute: .bottom,
      relatedBy: .equal,
      toItem: self,
      attribute: .bottom,
      multiplier: 1.0,
      constant: 0)
    
    let leadingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .leading,
      relatedBy: .equal,
      toItem: self,
      attribute: .leading,
      multiplier: 1.0,
      constant: 0)
    
    let trailingContraint = NSLayoutConstraint(
      item: subview,
      attribute: .trailing,
      relatedBy: .equal,
      toItem: self,
      attribute: .trailing,
      multiplier: 1.0,
      constant: 0)
    
    addConstraints([
      topContraint,
      bottomConstraint,
      leadingContraint,
      trailingContraint])
  }
  
}
