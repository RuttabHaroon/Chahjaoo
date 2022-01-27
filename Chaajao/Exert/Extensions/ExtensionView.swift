import Foundation
import UIKit

extension UIScrollView {

    func scrollTo(horizontalPage: Int? = 0, verticalPage: Int? = 0, animated: Bool? = true) {
        var frame: CGRect = self.frame
        frame.origin.x = frame.size.width * CGFloat(horizontalPage ?? 0)
        frame.origin.y = frame.size.width * CGFloat(verticalPage ?? 0)
        self.scrollRectToVisible(frame, animated: animated ?? true)
    }
    
    func scrollToBottom(animated: Bool) {
       if self.contentSize.height < self.bounds.size.height { return }
       let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
       self.setContentOffset(bottomOffset, animated: animated)
    }
    
    func scrollToTop(animated: Bool) {
      let bottomOffset = CGPoint(x: 0, y: 0)
        self.setContentOffset(bottomOffset, animated: animated)
    }

}

extension UIView {
    
	func  moveBottom (constantBottom: CGFloat,animation:Bool,constraint:NSLayoutConstraint,delay:Double,completion:(()->())?) {

		UIView.animate(withDuration: delay, animations: {
			constraint.constant = constantBottom
			self.superview?.layoutIfNeeded()

		}, completion: { (value) in
			completion?()
		})
	}
    
    func dropShadow(color: UIColor, opacity: Float = 0.1, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
    
}


extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }

    func attributeText (text: String) {
        let attributedString = NSMutableAttributedString(string: text)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        // *** set LineSpacing property in points ***
         // Whatever line spacing you want in points
        paragraphStyle.lineHeightMultiple = 1.5
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
    
}
extension UITableView {

    func  addrefreshControll (target:Any,method:Selector) -> UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action:method, for: UIControl.Event.valueChanged)
        refreshControl.tag = 2
        self.addSubview(refreshControl) // not required whe using UITableViewController
        return refreshControl
    }
    
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)//UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self) // defaults to the name of the class implementing this protocol.
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
extension UIColor {
    static var officialApplePlaceholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
}

