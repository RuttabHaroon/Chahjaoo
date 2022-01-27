
import UIKit

class DropDownCell: BaseUITableViewCell {

    @IBOutlet weak var leadingTitleConst: NSLayoutConstraint!
    @IBOutlet weak var leadingConst: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkboxImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var leadingCons : CGFloat? {
        didSet {
            leadingConst.constant = leadingCons ?? 0
            self.layoutIfNeeded()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateData(_ data: Any?) {
        super.updateData(data)
        let dropdown = data as? DropDownData
        titleLbl.text = dropdown?.titleValue
        checkboxImg.image =  UIImage(named: ( dropdown?.ischecked == true ) ? "check" : "uncheck")
    }
    
}
