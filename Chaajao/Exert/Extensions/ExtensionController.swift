import Foundation
import UIKit
import CoreLocation

extension UIViewController {
    
    func showCustomAlertWith(controller: UIViewController) {
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Void) in
            
            
        })
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertOKwithCompletion(message: String, title: String = "",completion:@escaping ()->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Void) in
            completion()
        })
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func alertwithCompletion(message: String, title: String = "",completion:@escaping (_ row:Int)->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Retry", style: .default, handler: { (Void) in
            completion(1)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (Void) in
            completion(0)
        })
        
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertwithMessage(message: String, title: String = "",completion:@escaping (_ row:Int)->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Void) in
            completion(1)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (Void) in
            completion(0)
        })
        
        alertController.addAction(OKAction)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertwithMessageWithOk(message: String, title: String = "",completion:@escaping ()->()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (Void) in
            completion()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func getController (controllerName:String) -> UIViewController{
       let storybaord =  UIStoryboard(name:controllerName, bundle:nil)
        let controller = storybaord.instantiateViewController(withIdentifier: controllerName)
        return controller
    }

}
