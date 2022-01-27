//
//  ProfileVC.swift
//  Chaajao
//
//  Created by Ahmed Khan on 07/09/2021.
//

import UIKit
import Kingfisher

class ProfileVC : BaseCustomController {
    
	@IBOutlet weak var notificationsBtn: BaseUIButton!
	@IBOutlet var tableView: BaseUITableView!
	@IBOutlet var editButton: BaseUIButton!
	@IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabel: BaseUILabel!
    @IBOutlet weak var profileImageView: BaseUIView!
    @IBOutlet weak var profileImage: BaseUIImageView!
    var vm = ProfileViewModel()
    var picker : ImagePicker?
    var isFormDisabled = true
	var list = [[String:Any]]()
	override func viewDidLoad() {
		super.viewDidLoad()
		addTableView()
		setupData()
        print("I AM ALIVEEEEE")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		reloadData()
	}

	func addTableView() {
		ExertUtility.addTableviewNibs(tableView: tableView, st:[ProfileInputCell.cellIdentifier, SingleButtonFooter.cellIdentifier])
		tableView.estimatedSectionFooterHeight =  0
		tableView.sectionFooterHeight = 0
		tableView.isScrollEnabled = false
		tableView.restore()
	}

	func reloadData() {
        
        self.profileImageView.backgroundColor = .clear
        print(UserPreferences.shared().userModelData?.profileImage ?? "")
        self.profileImage.kf.setImage(with: URL(string: UserPreferences.shared().userModelData?.profileImage ?? ""))
        
		delay(0.05, closure: {
			self.tableView.reloadData()
			self.tableViewHeightConstraint.constant = self.tableView.contentSizeHeight
		})
	}
    
    
    @objc func onProfilePictureTapped() {
        picker = ImagePicker(presentationController: self, delegate: self)
        picker?.present(from: self.view)
    }
    

	@IBAction func openNotifications() {
		let vc = NotificationsVC.instantiate(fromAppStoryboard: .main)
		APP_DELEGATE.navController.pushViewController(vc, animated: true)
	}

	@IBAction func back() {
		backButtonTapped()
	}
	func setupData() {
        self.usernameLabel.text = "\(salutation) \(UserPreferences.shared().userModelData?.name ?? "")"
		self.list.removeAll()
        let u = UserPreferences.shared().userModelData
        addInputCell(titleLabel: "Name", inputFieldText: u?.name ?? "", inputFieldPlaceholder: "Name", disabled: isFormDisabled, iconName: "Navigation.Profile")

        addInputCell(titleLabel: "Email", inputFieldText: u?.email ?? "", inputFieldPlaceholder: "Email", disabled: isFormDisabled, iconName: "Email")

        addInputCell(titleLabel: "Mobile No.", inputFieldText: u?.phoneNumber ?? "", inputFieldPlaceholder: "Mobile No.", disabled: isFormDisabled, iconName: "Smart.Phone")

        addInputCell(titleLabel: "Whatsapp No.", inputFieldText: u?.whatsappNumber ?? "", inputFieldPlaceholder: "Whatsapp No.", disabled: isFormDisabled, iconName: "Whatsapp")

        addDropDownCell(titleLabel: "Gender", selectedText: u?.gender ?? "Male", placeholder: "", disabled: isFormDisabled, iconName: "Gender")

        addInputCell(titleLabel: "Date of Birth", inputFieldText: u?.dob ?? "", inputFieldPlaceholder: "Date of Birth", disabled: isFormDisabled, iconName: "Calendar")

        addInputCell(titleLabel: "Address", inputFieldText: u?.address ?? "", inputFieldPlaceholder: "Address", disabled: isFormDisabled, iconName: "Location.Pin.2")

        addDropDownCell(titleLabel: "City", selectedText: u?.city ?? "", placeholder: "City", disabled: isFormDisabled, iconName: "City")

        addDropDownCell(titleLabel: "Country", selectedText: u?.country ?? "", placeholder: "Country", disabled: isFormDisabled, iconName: "Globe")

        addInputCell(titleLabel: "Last Institute Attended", inputFieldText: u?.lastInstitute ?? "PAF KIET", inputFieldPlaceholder: "Last Institute Attended", disabled: isFormDisabled, iconName: "GraduationCap")

		addFooter()
        
        let taap = UITapGestureRecognizer(target: self, action: #selector(onProfilePictureTapped))
        profileImageView.isUserInteractionEnabled = true
        self.profileImageView.addGestureRecognizer(taap)
	}

	func addFooter() {
		var dict = [String:Any]()
		dict["cellType"] = cellType.singleBtnFooterCell
		dict["title"] = "CHANGE PASSWORD"
		dict["isUserInteractionEnabled"] = true
		list.append(dict)
	}

	func addInputCell(titleLabel: String, inputFieldText: String, inputFieldPlaceholder: String, disabled: Bool, iconName: String) {
		var dict = [String:Any]()
		dict["cellType"] = cellType.profileInputCell
		dict["titleLabel"] = titleLabel
		dict["inputFieldText"] = inputFieldText
		dict["inputFieldPlaceholder"] = inputFieldPlaceholder
		dict["disabled"] = disabled
		dict["iconName"] = iconName
		list.append(dict)
	}

	func addDropDownCell(titleLabel: String, selectedText: String, placeholder: String, disabled: Bool, iconName: String) {
		var dict = [String:Any]()
		dict["cellType"] = cellType.profileInputCell
		dict["titleLabel"] = titleLabel
		dict["selectedText"] = selectedText
		dict["inputFieldText"] = selectedText
		dict["placeholder"] = placeholder
		dict["disabled"] = disabled
		dict["iconName"] = iconName
		list.append(dict)
	}

	func navToEditProfileVc() {
		let editVc = EditProfileVC.instantiate(fromAppStoryboard: .userAccess)
		editVc.fromProfile = true
		APP_DELEGATE.navController.pushViewController(editVc, animated: true)
	}
}

//MARK: TableViewDelegates
extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return setHeight(indexPath: indexPath)
	}

	func setHeight (indexPath: IndexPath) -> CGFloat {
		let dict = self.list[indexPath.row]

		if dict["isHidden"] as? Bool ?? false {
			return 0
		}
		switch (dict["cellType"] as? cellType ?? cellType.profileInputCell) {
			default:
				return UITableView.automaticDimension
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: BaseUITableViewCell!
		let data = self.list[indexPath.row]

		switch data["cellType"] as? cellType {
			case .profileInputCell:

				let tempCell = tableView.dequeueReusableCell(withIdentifier: ProfileInputCell.cellIdentifier) as! ProfileInputCell
				tempCell.updateData(data)
				tempCell.delegate = self
				cell = tempCell
			case .singleBtnFooterCell:
				let tempCell = tableView.dequeueReusableCell(withIdentifier: SingleButtonFooter.cellIdentifier) as! SingleButtonFooter
				tempCell.updateData(data)
				tempCell.delegate = self
				cell = tempCell
			default:
				return BaseUITableViewCell()
		}
		return cell
	}

}
//MARK: ProfileVC IBActions
extension ProfileVC {
	@IBAction func editTapped() {
		navToEditProfileVc()
	}

	func navToChangePassword() {
		let changePasswordVc = ChangePasswordVC.instantiate(fromAppStoryboard: .userAccess)
		APP_DELEGATE.navController.pushViewController(changePasswordVc, animated: true)
	}
}

//MARK: ProfileInputCellDelegate
extension ProfileVC : ProfileInputCellDelegate {

	func inputFieldEdited(cell: ProfileInputCell) {
		//TODO
	}

	func inputFieldEditingDidEnd(cell: ProfileInputCell) {
		//TODO
	}
}

extension ProfileVC : SingleButtonFooterDelegate {
	func buttonTapped(cell: SingleButtonFooter) {
		navToChangePassword()
	}
}

extension ProfileVC : ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image {
            vm.updateProfilePic(image: img)
            vm.onProfilePictUpdated = { [weak self] imageURL in
                self?.profileImage.kf.setImage(with: URL(string: imageURL))
            }
        }
        else {
            Utility.showHudWithError(errorString: "No Image Selected!")
        }
    }
}
