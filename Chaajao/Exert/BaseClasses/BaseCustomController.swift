
import UIKit
import ObjectMapper
import IQKeyboardManagerSwift
import Alamofire

class BaseCustomController: BaseUIViewController {
    var queryf: String!
    var multiPickerView : MultiPickerView?
    var datePickerView : DatePickerView?
	var confirmationView: ConfirmationActionSheetView?
    var hasNetworkRequests = true
    var offset = 0
    var isrunning: Bool = false
    var hasloaded = false
    var showHud = true

    func dropDownView() {
        multiPickerView =  MultiPickerView.loadNib() as? MultiPickerView
        multiPickerView?.isHidden = true
        multiPickerView?.addTableView()
        self.view.addSubview(multiPickerView!)
        multiPickerView?.bottomConstraintMulti = Constraints.leadingTrailingBottomTopToSuperView(subview: multiPickerView!, superView: self.view, constant: 500, attriableValue:.bottom)
        
        let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: multiPickerView!, superView: self.view, constant: 0, attriableValue:.leading)
        
        let _  = Constraints.leadingTrailingBottomTopToSuperView(subview: multiPickerView!, superView: self.view, constant: 0, attriableValue:.trailing)
        
        let _ = Constraints.fixedWidthHeightToSuperView(subview: multiPickerView!, superView:  self.view, constant: UIScreen.main.bounds.size.height * 0.35, attributeValue: .height, toItemAttributeValue: .notAnAttribute, constraintTo: nil)
    }

	func setupConfirmationActionView() {
		confirmationView = ConfirmationActionSheetView.loadNib() as? ConfirmationActionSheetView
		confirmationView?.isHidden = true
		var heightForView: CGFloat = 0
		if ExertUtility.isIPad {
			heightForView = self.view.frame.height < self.view.frame.width ? self.view.frame.height :  self.view.frame.width
		} else {
			heightForView = self.view.frame.height > self.view.frame.width ? self.view.frame.height :  self.view.frame.width
		}

		self.view.addSubview(confirmationView!)
		confirmationView?._bottomConstraint = Constraints.leadingTrailingBottomTopToSuperView(subview: confirmationView!, superView: self.view, constant: heightForView * 0.7, attriableValue: .bottom)
		let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: confirmationView!, superView: self.view, constant: 0, attriableValue:.leading)
		let _  = Constraints.leadingTrailingBottomTopToSuperView(subview: confirmationView!, superView: self.view, constant: 0, attriableValue:.trailing)
		let _ = Constraints.fixedWidthHeightToSuperView(subview: confirmationView!
														, superView:  self.view, constant: heightForView * 0.7, attributeValue: .height, toItemAttributeValue: .notAnAttribute, constraintTo: nil)
	}

    func addDatePicker() {
        datePickerView = DatePickerView.loadNib() as? DatePickerView
        datePickerView?.isHidden = true
        self.view.addSubview(datePickerView!)
        datePickerView?.bottomConstraintMulti = Constraints.leadingTrailingBottomTopToSuperView(subview: datePickerView!, superView: self.view, constant: 500, attriableValue:.bottom)
        
        let _ = Constraints.leadingTrailingBottomTopToSuperView(subview: datePickerView!, superView: self.view, constant: 0, attriableValue:.leading)
        
        let _  = Constraints.leadingTrailingBottomTopToSuperView(subview: datePickerView!, superView: self.view, constant: 0, attriableValue:.trailing)
        
        let _ = Constraints.fixedWidthHeightToSuperView(subview: datePickerView!
                                                        , superView:  self.view, constant: UIScreen.main.bounds.size.height * 0.36, attributeValue: .height, toItemAttributeValue: .notAnAttribute, constraintTo: nil)
    }
    
    func removeDatePicker() {
        if datePickerView != nil {
            self.view.willRemoveSubview(datePickerView!)
            datePickerView?.removeFromSuperview()
        }
    }

	func showConfirmationView() {
		confirmationView?.isHidden = false
		self.view.bringSubviewToFront(confirmationView!)
		confirmationView?.moveBottom(constantBottom: 0, animation: true, constraint: (confirmationView?.bottomConstraint)!, delay: 0.5, completion: {
			self.setAllSubViewInteraction(interaction: false)
		})
		confirmationView?.resignFirstResponder()
		confirmationView?.setNeedsFocusUpdate()
	}

	func hideConfirmationView() {
		confirmationView?.moveBottom(constantBottom: (confirmationView?.frame.height)!, animation: true, constraint: (confirmationView?.bottomConstraint)!, delay: 0.5, completion: {
			self.confirmationView?.isHidden = true
			self.setAllSubViewInteraction(interaction: true)
		})
	}
    
    func dropdownshow() {
        multiPickerView?.isHidden = false
        self.view.bringSubviewToFront(multiPickerView!)
        multiPickerView?.moveBottom(constantBottom: 0, animation: true, constraint: (multiPickerView?.bottomConstraintMulti)!, delay: 0.5, completion: {
            self.setAllSubViewInteraction(interaction: false)
        })
        multiPickerView?.resignFirstResponder()
        multiPickerView?.setNeedsFocusUpdate()
    }
    
    func dropdownhide() {
        multiPickerView?.moveBottom(constantBottom: 500, animation: true, constraint: (multiPickerView?.bottomConstraintMulti)!, delay: 0.5, completion: {
            self.multiPickerView?.isHidden = true
            self.setAllSubViewInteraction(interaction: true)
        })
    }
    
    func datePickershow() {
        datePickerView?.isHidden = false
        
        datePickerView?.datePick.setDate(Date(), animated: false)
        
        self.view.bringSubviewToFront(datePickerView!)
        datePickerView?.moveBottom(constantBottom: 0, animation: true, constraint: (datePickerView?.bottomConstraintMulti)!, delay: 0.5, completion: {
            self.setAllSubViewInteraction(interaction: false)
        })
        
    }
    
    func datePickerhide() {
        
        datePickerView?.moveBottom(constantBottom: 500, animation: true, constraint: (datePickerView?.bottomConstraintMulti)!, delay: 0.5, completion: {
            self.datePickerView?.isHidden = true
            self.setAllSubViewInteraction(interaction: true)
        })
    }
    
    //MARK: OVERRIDE FUNC
    override func viewDidLoad() {
        super.viewDidLoad()
		dropDownView()
		setNeedsStatusBarAppearanceUpdate()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.delegate = APP_DELEGATE.navController

        self.navigationController?.navigationBar.viewWithTag(-1)?.removeFromSuperview()

		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {

		if #available(iOS 13.0, *) {
			return .darkContent
		} else {
			return .default
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self as? TestMainVC != nil || self as? SolutionsMainVC != nil || self as? TestResultVC != nil {
			AppDelegate.AppUtility.lockOrientation(.allButUpsideDown)
		}
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		APP_DELEGATE.navController.navigationBar.viewWithTag(-1)?.removeFromSuperview()
        self.view.viewWithTag(1)?.removeFromSuperview()
		APP_DELEGATE.navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
		APP_DELEGATE.navController.navigationBar.shadowImage = UIImage()
		APP_DELEGATE.navController.navigationBar.tintColor = UIColor.black
		APP_DELEGATE.navController.setNavigationBarHidden(true, animated: false)
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]

        if hasNetworkRequests {
            delay(1, closure: {
                if !REACHABILITY_HELPER.isInternetConnected {
                    APP_DELEGATE.hideProgressHud()
                    self.showHud = true
                    HTTPServiceManager.cancelAllRequests()
//                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
        }
		if self as? TestMainVC != nil || self as? SolutionsMainVC != nil || self as? TestResultVC != nil {
			AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
		}
		setNeedsStatusBarAppearanceUpdate()
    }

	deinit {
		if self as? TestMainVC != nil || self as? SolutionsMainVC != nil || self as? TestResultVC != nil {
			AppDelegate.AppUtility.lockOrientation(.allButUpsideDown)
		}
	}

	func colorizeImage(_ image: UIImage?, with color: UIColor?) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(image?.size ?? CGSize.zero, _: false, _: image?.scale ?? 0.0)

		let context = UIGraphicsGetCurrentContext()
		let area = CGRect(x: 0, y: 0, width: image?.size.width ?? 0.0, height: image?.size.height ?? 0.0)

		context?.scaleBy(x: 1, y: -1)
		context?.translateBy(x: 0, y: -area.size.height)

		context?.saveGState()
		context?.clip(to: area, mask: (image?.cgImage)!)

		color?.set()
		context?.fill(area)

		context?.restoreGState()

		if let context = context {
			context.setBlendMode(.multiply)
		}

		context!.draw((image?.cgImage)!, in: area)

		let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()

		return colorizedImage
	}
    
    override func rightButtonTapped(sender: UIButton) {
        if sender.tag == 2 {
            
        } else if sender.tag == 1 {
            
        } else if sender.tag == 0 {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
			if touch.view?.accessibilityIdentifier != "mulitipicker" && touch.view?.accessibilityIdentifier != "datepicker" &&  touch.view?.accessibilityIdentifier != "confirmationView" {
                self.dropdownhide()
                self.datePickerhide()
                setAllSubViewInteraction(interaction: confirmationView?.isHidden ?? true)
            }
        }
    }
    
    func setAllSubViewInteraction (interaction: Bool) {
        for subview in self.view.subviews {
            if (subview as? MultiPickerView) == nil && (subview as? DatePickerView) == nil && (subview as? ConfirmationActionSheetView) == nil {
                subview.isUserInteractionEnabled = interaction
            }
        }
    }
}

extension NSAttributedString.Key {
    static let tappedOnSubString = NSAttributedString.Key(rawValue: "TappedOnString")
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    func numberInWords() -> String {
        var wordNumber = ""

        let numberValue = NSNumber(value: Int32(self))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        wordNumber = numberFormatter.string(from: numberValue) ?? ""
        return wordNumber
    }
}
extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

//MARK:- NavigationBar Customization
extension BaseCustomController {
	func addButtonToNavigation(button: UIButton) {
		let butt = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItems?.removeAll()
		var buttonlist = [UIBarButtonItem]()
		buttonlist.append(butt)
		self.navigationItem.rightBarButtonItems = buttonlist
		self.view.bringSubviewToFront(button)
	}
}
//MARK: Share Text Menu
extension BaseCustomController {
	func shareApp() {

		let activityViewController = UIActivityViewController(activityItems: [appSharingText], applicationActivities: nil)

		// so that iPads won't crash:
		activityViewController.popoverPresentationController?.sourceView = self.view

		// exclude some activity types from the list (optional):
//		activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

		// present the view controller
		self.present(activityViewController, animated: true, completion: nil)
	}

	func shareImage(image: UIImage) {
		let imageToShare = [image]
		let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		self.present(activityViewController, animated: true, completion: nil)
	}
}

extension BaseCustomController {
	func addTableView(tableView: BaseUITableView, identifiers: [String]) {
		ExertUtility.addTableviewNibs(tableView: tableView, st: identifiers)
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.restore()
	}
}
