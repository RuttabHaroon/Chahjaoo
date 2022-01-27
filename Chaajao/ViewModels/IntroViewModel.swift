//
//  IntroViewModel.swift
//  Chaajao
//
//  Created by Ahmed Khan on 06/10/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class IntroViewModel {
	var items = [Result]()
    //var items = [[String:Any]]()
	var itemsUpdated:()->Void = {}
	var count = 0 {
		didSet {
			self.itemsUpdated()
		}
	}

	init() {
		//getItems()
        fetchItemsFromAPI()
	}

//	func getItems() {
//		items.removeAll()
//		count = 0
//		items.append(IntroModel(type: "image", title: "Hi there!", description: "Welcome to Chaajao. We're excited to have you here. Let's begin with the basics. Swipe left to start. Or if you'd like to skip through, tap on the \"SKIP\" button in the bottom right corner.", contentLink: "https://raw.githubusercontent.com/mujtaba617/Chaajao-Demo-Images/e36d47984c071277a27edb4eeffd877250dca1a0/circular.png"))
//		items.append(IntroModel(type: "image", title: "Basics", description: "Welcome to Chaajao. We're excited to have you here. Let's begin with the basics. Swipe left to start. Or if you'd like to skip through, tap on the \"SKIP\" button in the bottom right corner.", contentLink: "https://raw.githubusercontent.com/mujtaba617/Chaajao-Demo-Images/main/square_new.jpg"))
//
//		items.append(IntroModel(type: "video", title: "Message from creators", description: "Welcome to Chaajao. We're excited to have you here. Let's begin with the basics. Swipe left to start. Or if you'd like to skip through, tap on the \"SKIP\" button in the bottom right corner.", contentLink: "PLe3pznz9oM"))
//		count = items.count
//	}
    
    func fetchItemsFromAPI() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .introscreen),
                                   parameters: nil,
                                   showHud: true,
                                   method: .get,
                                   delegate: nil,
                                   otherData: nil,
                                   encoding: JSONEncoding.default)
            .onSuccess { [weak self] (httpRequest, data) in
                guard let weakSelf = self else {return}
                let dict:[String:Any] = data as! [String:Any]
                if let results = dict["result"] as? [[String:Any]] {
                    if weakSelf.items.count > 0 {
                        weakSelf.items.removeAll()
                    }
                    results.forEach { d in
                        let r = Result(
                                id: d["id"] as? Int ?? 0,
                                title: d["title"] as? String ?? "",
                                subTitle: d["subTitle"] as? String ?? "",
                                startDate: d["startDate"] as? String ?? "",
                                endDate: d["endDate"] as? String ?? "",
                                description: d["description"] as? String ?? "",
                                link: d["link"] as? String ?? "",
                                type: d["type"] as? String ?? "",
                                buttonText: d["buttonText"] as? String ?? "",
                                buttonLink: d["buttonLink"] as? String ?? "")
                        
                        weakSelf.items.append(r)
                    }
                    weakSelf.count = weakSelf.items.count
                }
            }.onFailure {[weak self] (httpRequest, error) in
                //MARK: TODO
                guard let weakSelf = self else {return}
                weakSelf.items.removeAll()
                weakSelf.count = 0
                print(error.localizedDescription)
                let dict:[String:Any] = [
                    "message": "POST Request unsuccessful.",
                    "isError": true,
                    "responseException": error.localizedDescription
                ]
                
            }
        
    }
    
}
