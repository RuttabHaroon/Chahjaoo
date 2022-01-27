import UIKit

class ActionSheet: NSObject {
     class func showSheet(_ completion: @escaping (_ row :Int)->(),buttonlist : [String],title : String)->UIAlertController{
        
        let actionSheet = UIAlertController(title:title, message: "", preferredStyle:
            UIAlertController.Style.actionSheet)
        
        for i in 0...buttonlist.count-1 {
            
            let libButton = UIAlertAction(title:  buttonlist[i], style:.default) { (libSelected) ->  Void in
                
                completion (i)
            }
            actionSheet.addAction(libButton)
        }
        let cancel = UIAlertAction(title:"Cancel", style:.cancel) { (libSelected) ->  Void in
    
        }
        actionSheet.addAction(cancel)
        return actionSheet
    }
}
