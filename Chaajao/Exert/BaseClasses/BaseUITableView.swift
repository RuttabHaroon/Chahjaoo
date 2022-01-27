
import UIKit


open class BaseUITableView: UITableView {

    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib()
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
    } //F.E.

    open override func reloadData() {
        super.reloadData()
        
        if self.numberOfRows(inSection: 0) == 0 && HTTPServiceManager.sharedInstance._requests.count == 1 && APP_DELEGATE.isProgressVisible() {
            self.setEmptyMessage("No data found. Pull down to refresh.")
        } else {
            restore()
        }
    }
} //CLS END

extension UITableView {

    func setEmptyMessage(_ message: String = "No data found. Pull down to refresh.") {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
		messageLabel.font = UIFont(name: "SegoeUI", size: ExertUtility.convertToRatio(14))
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
	
	var contentSizeHeight: CGFloat {
		var height = CGFloat(0)
		for section in 0..<numberOfSections {
			height = height + rectForHeader(inSection: section).height
			let rows = numberOfRows(inSection: section)
			for row in 0..<rows {
				height = height + rectForRow(at: IndexPath(row: row, section: section)).height
			}
		}
		return height
	}
}
