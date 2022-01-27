
import UIKit

// MARK: - UITableView extension for Utility Method
public extension UITableView {
    
    func scrollToBottom(_ animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1));
                
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    } //F.E
    
    
    
    func scrollToTop(_ animated: Bool = true) {
        self.setContentOffset(CGPoint.zero, animated: animated);
    } //F.E.
    
} //E.E.
