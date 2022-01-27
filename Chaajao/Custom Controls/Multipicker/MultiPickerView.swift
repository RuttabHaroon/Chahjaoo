

import UIKit

@objc protocol MultiPickerViewDelegate: AnyObject {
    
    @objc optional  func didSelectRowAt (row: Int)
    @objc optional  func pickerDoneClicked (tag: Int, dropDownData: DropDownData?, cell: UITableViewCell?)
    @objc optional  func pickerMultipleClicked (tag: Int, dropDownData: [DropDownData]?)
    
    @objc optional  func pickerDoneHeaderClicked (tag: Int, dropDownData: DropDownData?, dropdownHeader: DropDownData)
    @objc optional  func pickerHeaderMultipleClicked (tag: Int, dropDownData: [DropDownData]?, dropdownHeader: [DropDownData]?)
}



class MultiPickerView: BaseUIView {
  
    @IBOutlet weak var doneTitle: BaseUIButton!
    @IBOutlet weak var titleValue: BaseUILabel!
    var bottomConstraintMulti : NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var dropdown: [DropDownData]?
    var cell: UITableViewCell?
    var dropdownHeaderList: [DropDownData]?
    var selectedRow: Int = 0
    var isHeader = false
    
    var selectedDropDown: [DropDownData]? {
        didSet {
            if self.isHeader {
                for i in 0..<(self.dropdown?.count ?? 0)! {
                    if selectedDropDown?.contains(where: {$0.Id == self.dropdown?[i].Id}) ?? false == true {
                        self.dropdown?[i].ischecked = true
                    }
                }
                
                for i in 0..<(self.dropdownHeaderList?.count ?? 0)! {
                    if selectedDropDown?.contains(where: {$0.Id == self.dropdownHeaderList?[i].Id}) ?? false == true {
                        self.dropdownHeaderList?[i].ischecked = true
                    }
                }
                
            } else {
                for i in 0..<(self.dropdown?.count ?? 0)! {
                    if selectedDropDown?.contains(where: {$0.Id == self.dropdown?[i].Id}) ?? false == true {
                        self.dropdown?[i].ischecked = true
                    }
                }
            }

        }
    }
    
    var selectedHeaderDropDown: [DropDownData]?
    
    var isMultSelection: Bool = false {
        didSet {
            self.doneTitle.isHidden = !isMultSelection
            
        }
    }
    
    weak var delegate: MultiPickerViewDelegate?
   
    var titleLabel: String? {
        didSet {
            titleValue.text =  titleLabel
        }
    }
    
    func addTableView() {
        ExertUtility.addTableviewNibs(tableView: tableView, st:[DropDownCell.cellIdentifier])
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func selectedRow(row: Int, ischecked: Bool) {
        dropdown?[row].ischecked = ischecked
    }

    func uncheckall(indexpath: IndexPath) {
        for i in 0..<(self.dropdown?.count ?? 0)! {
            if i != indexpath.row {
                dropdown?[i].ischecked = false
                (self.tableView.cellForRow(at: indexpath) as? DropDownCell)?.updateData(dropdown?[i])
            }
        }
        for cell in self.tableView.visibleCells {
            if cell.tag != indexpath.row {
                (cell as? DropDownCell)?.updateData(dropdown?[cell.tag])
            }
        }
    }
    
    func checkall(section: Int) {
        for i in 0..<(self.dropdown?.count ?? 0)! {
            if self.dropdown?[i].section ?? 0 == section{
                dropdown?[i].ischecked = true
               // print("check all:\(dropdown?[i].titleValue ?? "")")
            }
        }
        
        for cell in self.tableView.visibleCells {
            if ((cell as? DropDownCell)?.data as? DropDownData)?.section == section {
                (cell as? DropDownCell)?.updateData(dropdown?[cell.tag])
            }
        }
    }
    
    func uncheckallFromHeader(section: Int) {
        for i in 0..<(self.dropdown?.count ?? 0)! {
            if self.dropdown?[i].section ?? 0 == section{
                dropdown?[i].ischecked = false
            }
        }
        
        for cell in self.tableView.visibleCells {
            if ((cell as? DropDownCell)?.data as? DropDownData)?.section == section {
                (cell as? DropDownCell)?.updateData(dropdown?[cell.tag])
            }
        }
    }
    
    @IBAction func pickerDoneClicked(_ sender: Any) {
        if isMultSelection == true {
            if self.isHeader {
                delegate?.pickerHeaderMultipleClicked?(tag: self.tag, dropDownData: self.dropdown?.filter({$0.ischecked == true}) ?? [DropDownData](), dropdownHeader: self.dropdownHeaderList?.filter({$0.ischecked == true}) ?? [DropDownData]())
            } else {
                delegate?.pickerMultipleClicked?(tag: self.tag, dropDownData: self.dropdown?.filter({$0.ischecked == true}) ?? [DropDownData]())
            }
            
        } else {
            if (self.dropdown?.count ?? 0 > 0) {
                
                self.moveBottom(constantBottom: 500, animation: true, constraint: (self.bottomConstraintMulti)!, delay: 0.5, completion: {
                    self.isHidden = true
                })
            } else {
                return
            }
            
            delegate?.pickerDoneClicked?(tag: self.tag, dropDownData: self.dropdown?[self.selectedRow], cell: self.cell)
        }

    }

}



//MARK: DropdownHeaderDelegate
extension MultiPickerView: DropdownHeaderDelegate {

    func didSelectRowAt(row: Int) {
        if dropdownHeaderList?[row].ischecked == true {
            dropdownHeaderList?[row].ischecked = false
            uncheckallFromHeader(section: dropdownHeaderList?[row].Id ?? 0)
        } else {
            dropdownHeaderList?[row].ischecked = true
            checkall(section: dropdownHeaderList?[row].Id ?? 0)
        }
        let indexSet: IndexSet = [row]
        self.tableView.reloadSections(indexSet, with: .none)
   
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension MultiPickerView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExertUtility.convertToRatio(40)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isHeader == true {
            return self.dropdownHeaderList?.count ?? 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isHeader == true {
            return self.dropdown?.filter({$0.section == self.dropdownHeaderList?[section].Id ?? 0}).count ?? 0
        } else {
            return self.dropdown?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isHeader {
            let dropdownHeader = DropdownHeader.loadNib() as? DropdownHeader
            dropdownHeader?.updateData(self.dropdownHeaderList?[section])
            dropdownHeader?.tag = section
            dropdownHeader?.delegate = self
            return dropdownHeader
        } else {
            return nil
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isHeader {
            return ExertUtility.convertToRatio(80)
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isMultSelection == true {
            if self.isHeader {
                if  self.dropdown?.filter({$0.section == self.dropdownHeaderList?[indexPath.section].Id ?? 0})[indexPath.row].ischecked == true {
                     self.dropdown?.filter({$0.section == self.dropdownHeaderList?[indexPath.section].Id ?? 0})[indexPath.row].ischecked = false
                } else {
                     self.dropdown?.filter({$0.section == self.dropdownHeaderList?[indexPath.section].Id ?? 0})[indexPath.row].ischecked = true
                }
                (self.tableView.cellForRow(at: indexPath) as? DropDownCell)?.updateData(self.dropdown?.filter({$0.section == self.dropdownHeaderList?[indexPath.section].Id ?? 0})[indexPath.row])
                delegate?.didSelectRowAt?(row: indexPath.row)
            } else {
                if dropdown?[indexPath.row].ischecked == true {
                    dropdown?[indexPath.row].ischecked = false
                } else {
                    dropdown?[indexPath.row].ischecked = true
                }
                (self.tableView.cellForRow(at: indexPath) as? DropDownCell)?.updateData(dropdown?[indexPath.row])
                delegate?.didSelectRowAt?(row: indexPath.row)
            }

        } else {
                self.selectedRow = indexPath.row
                uncheckall(indexpath:indexPath)
                if dropdown?[indexPath.row].ischecked == true {
                    dropdown?[indexPath.row].ischecked = false
                } else {
                    dropdown?[indexPath.row].ischecked = true
                }
               (self.tableView.cellForRow(at: indexPath) as? DropDownCell)?.updateData(dropdown?[indexPath.row])
            self.pickerDoneClicked(self)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dropdown : DropDownData!
        if self.isHeader == true {
            dropdown = self.dropdown?.filter({$0.section == self.dropdownHeaderList?[indexPath.section].Id ?? 0})[indexPath.row]
            
        } else {
            dropdown = self.dropdown?[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.cellIdentifier) as! DropDownCell
        cell.updateData(dropdown)
        cell.tag = indexPath.row
        if self.isMultSelection == false {
             cell.leadingTitleConst.priority =  UILayoutPriority(rawValue: 900)
            cell.layoutIfNeeded()
            cell.checkboxImg.isHidden = true
        } else {
            cell.leadingTitleConst.priority =  UILayoutPriority(rawValue: UILayoutPriority.RawValue(250))
            cell.checkboxImg.isHidden = false
            self.layoutIfNeeded()
            
        }

        if isHeader {
            cell.leadingCons = 45
        }
        return cell
    }
    
}
