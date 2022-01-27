//
//  AppDelegate.swift
//  Chaajao
//
//  Created by Ahmed Khan on 20/08/2021.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import ObjectMapper
import AVFoundation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var manager :Alamofire.SessionManager!
	var navController: BaseUINavigationController!
	var mainViewController : BaseUIViewController?
	var serverTrustPoliciesManager:ServerTrustPolicyManager!
	var orientationLock = UIInterfaceOrientationMask.allButUpsideDown

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//		printAvailableFonts()
		checkForJailBreak()
		setupUserDefaults()
		setupConnectivity()
		setupKeyboardMngr()
		setupRootView()
		setupPiP()
		setupRotationListener()
		setupUIWindow()
		return true
	}

	func showProgress() {
		DispatchQueue.main.async(execute: {
			self.showProgressHud()
		})
	} //F.E.

	func hideProgress() {
		DispatchQueue.main.async(execute: {
			self.hideProgressHud()
			HTTPServiceManager.onShowProgress(showProgress: self.showProgress);
			HTTPServiceManager.onHideProgress(hideProgress: self.hideProgress);
		})
	} //F.E.

	func isProgressVisible() -> Bool {
		return SVProgressHUD.isVisible()
	} //F.E.

	func showProgressHud(){
		SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
		SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
		SVProgressHUD.setBackgroundColor(.clear);
		SVProgressHUD.setForegroundColor(.red);
		SVProgressHUD.setRingThickness(3.0);
		SVProgressHUD.show();
	} //F.E.

	func hideProgressHud() {
		SVProgressHUD.dismiss()
	} //F.E.
    
    func showProgressHudWithError(errorMessage: String) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
        SVProgressHUD.setBackgroundColor(.clear);
        SVProgressHUD.setForegroundColor(.red);
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        SVProgressHUD.showError(withStatus: errorMessage);
    }
    
    func showProgressHudWithSucess(sucessMessage: String) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
        SVProgressHUD.setBackgroundColor(.clear);
        SVProgressHUD.setForegroundColor(.red);
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        SVProgressHUD.showSuccess(withStatus: sucessMessage)
    }
    
}

//MARK:- MessagePopupViewDelegate
extension AppDelegate: MessagePopupViewDelegate {
	func positiveBtnTapped(klcPopup: KLCPopup?, messagePopupView: MessagePopupView) {
		UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
	}
}
extension AppDelegate {
	struct AppUtility {
		static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
			APP_DELEGATE.orientationLock = orientation
		}
		static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
			self.lockOrientation(orientation)
			UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
		}
	}
}
//MARK:- Initial Setup
extension AppDelegate {

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.init(arrayLiteral: orientationLock)
	}

	func checkForJailBreak() {
		if UIDevice.current.isJailBroken {
			let popup = ExertUtility.messagePopup(message: "Chaajao can't run on devices with Jailbreak installed.")
			popup?.delegate = self
		}
	}

	func setupUserDefaults() {
		if !USER_DEFAULTS.isKeyCreated {
			USER_DEFAULTS.password = UUID().uuidString + UUID().uuidString
		}
		USER_DEFAULTS.synchronize()
	}

	func initializeNetworkManager() {
		HTTPServiceManager.initialize(serverBaseURL: baseURL)
		HTTPServiceManager.onShowProgress(showProgress: showProgress);
		HTTPServiceManager.onHideProgress(hideProgress: hideProgress);
	}
 
	func setupConnectivity() {
		REACHABILITY_HELPER.setupReachability()
		initializeNetworkManager()
	}

	func setupKeyboardMngr() {
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
	}

	func setupRootView() {
        //UserPreferences.shared().isLoggedIn = false
        if UserPreferences.shared().isLoggedIn {
			let viewController = MainTabVC.instantiate(fromAppStoryboard: .main)
			navController = BaseUINavigationController(rootViewController: viewController)
		} else {
			let viewController = SignInVC.instantiate(fromAppStoryboard: .userAccess)
			navController = BaseUINavigationController(rootViewController: viewController)
		}
		navController.fontName = EXERT_GLOBAL.fontName
		navController.fontSize = EXERT_GLOBAL.fontSize
		navController.bgColor = UIColor(named: "#F5F5F5")
		navController.navigationBar.tintColor = UIColor.white
		navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		navController.interactivePopGestureRecognizer?.isEnabled = true
	}

	func setupPiP() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.playback, mode: .moviePlayback)
		} catch {
			print("Failed to set audioSession category to playback")
		}

	}

	func setupRotationListener() {
		NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
	}

	func setupUIWindow() {
		window = UIWindow(frame: UIScreen.main.bounds)
		window!.backgroundColor = UIColor.white
		window!.rootViewController = navController
		window!.makeKeyAndVisible();
	}

	@objc func deviceRotated() {
//		if UIDevice.current.orientation != .unknown && UIDevice.current.orientation != .faceUp && UIDevice.current.orientation != .faceDown {
//
//		}
		sendNotification(notificationName: "setCornerView")
	}

	func printAvailableFonts() {
		for fontFamilyName in UIFont.familyNames{
			for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
				print("Family: \(fontFamilyName)\tFont: \(fontName)")
			}
		}
	}
}
