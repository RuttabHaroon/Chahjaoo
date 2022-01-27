//
//  NewsAdsCollectionViewCell.swift
//  Chaajao
//
//  Created by Ahmed Khan on 04/10/2021.
//

import UIKit
import Kingfisher

@objc protocol NewsAdsCollectionViewCellDelegate : AnyObject {
	@objc func itemTapped(cell: NewsAdsCollectionViewCell)
}

class NewsAdsCollectionViewCell: BaseUICollectionViewCell {
	@IBOutlet var youtubePlayer: YTPlayerView!
	@IBOutlet var gradientForTitle: BaseUIButton!
	@IBOutlet var thumbnailImageView: UIImageView!
	@IBOutlet var titleLabelView: UILabel!
	var model: NewsResult?
	var delegate: NewsAdsCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
		//youtubePlayer.delegate = self
    }


	override func updateData(_ data: Any?) {
		super.updateData(data)
		model = data as? NewsResult
		guard model != nil else {
			return
		}
        titleLabelView.text = model?.title ?? ""
        if model?.newsImage.contains("http") ?? false {
			let url = URL(string: model!.newsImage)
			thumbnailImageView.kf.setImage(with: url)
		}
//		if model?.isPlaying ?? false {
//			youtubePlayer.isHidden = false
//			youtubePlayer.load(withVideoId: model!.watchId)
//		} else {
//			youtubePlayer.isHidden = true
//			youtubePlayer.stopVideo()
//			youtubePlayer.releasePictureInPicture()
//		}
	}

	@IBAction func itemTapped() {
		delegate?.itemTapped(cell: self)
		if model?.newsImage.contains("http") ?? false {
			let vc = YoutubeVideoVC.instantiate(fromAppStoryboard: .main)
			vc.watchId = self.model!.link
			APP_DELEGATE.navController.pushViewController(vc, animated: true)
		}
	}
}

//extension NewsAdsCollectionViewCell : YTPlayerViewDelegate {
//	func playerView(_ playerView: YTPlayerView, didChangeToStatePictureInPicture state: String?) {
//		let enabled = (state == "picture-in-picture") ? true : false
//		self.youtubePlayer.pictureInPicture()
//	}
//
//	func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//		self.youtubePlayer.pictureInPicture()
//	}
//}
