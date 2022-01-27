
import UIKit

@objc protocol DropdownHeaderDelegate: class {
    
    @objc optional  func didSelectRowAt (row: Int)
    

}

class DropdownHeader: BaseUIView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var checkboxImg: UIImageView!
    
    weak var delegate: DropdownHeaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTapGesture(tapNumber: 1, target: self, action:#selector(didSelectHeader(_:)))
    }
    
    func updateData(_ data: Any?) {
        
//        let dropdown = data as? DropDownData
//        titleLbl.text = dropdown?.titleValue
//        checkboxImg.image =  UIImage(named: ( dropdown?.ischecked == true ) ? "check" : "uncheck")
    }

    @objc @IBAction func didSelectHeader(_ sender: Any) {
        delegate?.didSelectRowAt?(row: self.tag)
    }
    
}
