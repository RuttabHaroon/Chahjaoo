//
//  HomeVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 09/09/2021.
//

import Foundation
import AVKit
import AVFoundation
import Kingfisher
class HomeVC : BaseCustomController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var notificationsBtn: BaseUIButton!
    @IBOutlet weak var profileImageView: BaseUIImageView!
    @IBOutlet var newsCollectionView: UICollectionView!
	var newsAdsViewModel: NewsAdsViewModel!
    var userViewModel = UserViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
        newsAdsViewModel.getData()
        self.usernameLabel.text = "\(salutation) \(UserPreferences.shared().userModelData?.name ?? "")"
		setupModels()
		addCollectionView()
        
        userViewModel.userModelUpdated = {
            self.usernameLabel.text = salutation + (UserPreferences.shared().userModelData?.name ?? "")
            self.profileImageView.backgroundColor = .clear
            print(UserPreferences.shared().userModelData?.profileImage ?? "")
            self.profileImageView.kf.setImage(with: URL(string: UserPreferences.shared().userModelData?.profileImage ?? ""))
        }
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		APP_DELEGATE.navController.interactivePopGestureRecognizer?.isEnabled = true
		newsCollectionView.reloadData()
        userViewModel.getUserProfile()
	}

	@IBAction func secretTap() {
		let introVc = IntroVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(introVc, animated: true)
	}

	func setupModels() {
		newsAdsViewModel!.itemsUpdated = {
			self.newsCollectionView.reloadData()
		}
	}

	func addCollectionView() {
		ExertUtility.addcollectionView(collectionView:newsCollectionView, st:[NewsAdsCollectionViewCell.cellIdentifier])
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 10
		layout.minimumInteritemSpacing = 10
		newsCollectionView.isScrollEnabled = true
		newsCollectionView?.collectionViewLayout = layout
	}

}
//MARK: UICollectionViewDelegate
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsAdsViewModel?.items?.result.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsAdsCollectionViewCell.cellIdentifier, for: indexPath) as! NewsAdsCollectionViewCell
        cell.updateData(newsAdsViewModel?.items?.result[indexPath.row])
		cell.delegate = self
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 195, height: 110)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
}

//MARK: NewsAdsCollectionViewCellDelegate
extension HomeVC : NewsAdsCollectionViewCellDelegate {
	func itemTapped(cell: NewsAdsCollectionViewCell) {
//        for i in 0..<(newsAdsViewModel?.items?.result.count ?? 0) {
//			newsAdsViewModel?.items[i].isPlaying = newsAdsViewModel?.items[i].watchId == cell.model?.watchId
//		}
//		newsCollectionView.reloadData()
	}
}

//MARK: IBActions
extension HomeVC {

	@objc func playVideo() {
		guard let path = Bundle.main.path(forResource: "demo", ofType:"mp4") else {
			debugPrint("demo.mp4 not found")
			return
		}
		let player = AVPlayer(url: URL(fileURLWithPath: path))
		let playerController = AVPlayerViewController()
		playerController.allowsPictureInPicturePlayback = true
		playerController.player = player
		present(playerController, animated: true) {
			player.play()
		}
	}

	@IBAction func openNotifications() {
		let vc = NotificationsVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}

	@IBAction func shareWithFriendsTapped() {
		shareApp()
	}

	@IBAction func navToResultsVc() {
		let resultsVc = PracticeZoneResultVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(resultsVc, animated: true)
	}

	@IBAction func navToProfile() {
		let profileVc = ProfileVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(profileVc, animated: true)
	}

	@IBAction func goToSampleQuestions() {
		let practiceTestsVc = PracticeTestsVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(practiceTestsVc, animated: true)
	}

	@IBAction func navToPracticeZone() {
		let practiceZone = PracticeZoneVC.instantiate(fromAppStoryboard: .practiceZone)
		APP_DELEGATE.navController.pushViewController(practiceZone, animated: true)
	}
}
