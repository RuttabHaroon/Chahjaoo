

import Foundation
class DropDownData: NSObject {
    
    var Id: Int?
    var ischecked: Bool?;
    var titleValue: String?;
    var section: Int?
    
    init(ischecked: Bool, titeValue: String, Id: Int, section: Int = 1) {
        super.init();
        self.ischecked = ischecked
        self.titleValue = titeValue
        self.Id = Id
        self.section = section
    }
    
    func convertDict () ->[String: Any] {
        var dict = [String: Any]()
        
        dict["name"] = self.titleValue ?? ""
        dict["dataId"] = self.Id ?? 0
        return dict
    }
    
}
