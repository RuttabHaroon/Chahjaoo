//
//  YoutubeVideoVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 11/10/2021.
//

import Foundation

class YoutubeVideoVC : BaseCustomController {
	@IBOutlet var youtubePlayer: YTPlayerView!
	var watchId = ""
	var didLoadOnce = false
	override func viewDidLoad() {
		super.viewDidLoad()
		youtubePlayer.delegate = self
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = false
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if !didLoadOnce {
			loadVideo()
		}
	}

	func loadVideo() {
		delay(0, closure: {
			self.youtubePlayer.load(withVideoId: self.watchId)
			self.didLoadOnce = true
		})
	}

	@IBAction func back() {
		self.youtubePlayer.stopVideo()
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		backButtonTapped()
	}
}

extension YoutubeVideoVC : YTPlayerViewDelegate {
	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
		self.youtubePlayer.playVideo()
	}
}
