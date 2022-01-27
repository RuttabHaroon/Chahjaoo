

import UIKit

@objc protocol DatePickerViewDelegate: AnyObject {
    
    @objc optional  func cancelDatePicker (tag: Int)
    @objc optional  func datePickerDoneClicked (tag: Int,date: Date, cell: UITableViewCell?)
}

class DatePickerView: BaseUIView {

    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var doneTitle: BaseUIButton!
    @IBOutlet weak var titleValue: BaseUILabel!
    var bottomConstraintMulti : NSLayoutConstraint!
    var cell: UITableViewCell?
    var selectedRow: Int = 0

    weak var delegate: DatePickerViewDelegate?
    
    @IBAction func cancelDatePicker(_ sender: Any) {
        self.moveBottom(constantBottom: 500, animation: true, constraint: (self.bottomConstraintMulti)!, delay: 0.5, completion: {
            self.isHidden = true
			self.cancelDatePicker(self.tag)
        })
    }
    
    @IBAction func datePickerDoneClicked(_ sender: Any) {
        delegate?.datePickerDoneClicked?(tag: self.tag, date: self.datePick.date, cell: self.cell)
    }
}
