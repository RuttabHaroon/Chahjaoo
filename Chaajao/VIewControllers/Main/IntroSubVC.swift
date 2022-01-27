//
//  IntroSubVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 05/10/2021.
//

import Foundation
import Kingfisher
import SVProgressHUD
import UIKit

class IntroSubVC : BaseCustomController {
	@IBOutlet var alignYAxisConstraint: NSLayoutConstraint!
	@IBOutlet var topSpaceConstraint: NSLayoutConstraint!
	@IBOutlet var playerBg: UIView!
	@IBOutlet var youtubePlayer: YTPlayerView!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var titleLabel: BaseUILabel!
	@IBOutlet var descriptionLabel: BaseUILabel!
	@IBOutlet var stackView: UIStackView!

	var introModel: Result?
	var didSetViews = false

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: Notification.Name("introOrientationUpdate"), object: nil)
	}

	@IBAction func play() {
		if introModel?.type != "image" {
			let vc = YoutubeVideoVC.instantiate(fromAppStoryboard: .main)
			vc.watchId = self.introModel!.link
			APP_DELEGATE.navController.pushViewController(vc, animated: true)
		}
	}

	@objc func orientationChanged() {
		if UIDevice.current.orientation == .portrait {
			alignYAxisConstraint.priority = UILayoutPriority(1)
			topSpaceConstraint.priority = UILayoutPriority(1000)
			stackView.axis = .vertical
		} else {
			alignYAxisConstraint.priority = UILayoutPriority(1000)
			topSpaceConstraint.priority = UILayoutPriority(1)
			stackView.axis = .horizontal
		}
	}

    
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
		if !didSetViews {
			titleLabel.text = introModel?.title
			descriptionLabel.text = introModel?.description
            if introModel?.type.lowercased() == "image" {
				if introModel?.title == "Basics" {
					imageView.contentMode = .scaleAspectFill
				}
				let url = URL(string: introModel!.link)
				imageView.kf.setImage(with: url)
			} else {
				imageView.isHidden = true
				playerBg.isHidden = false
				youtubePlayer.isHidden = false
                
               
                if let uTubeID = getYoutubeId(youtubeUrl: self.introModel?.link ?? "") {
                    self.youtubePlayer.load(withVideoId: uTubeID)
                }
                
			}
			didSetViews = true
		}
		orientationChanged()
	}
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
}

