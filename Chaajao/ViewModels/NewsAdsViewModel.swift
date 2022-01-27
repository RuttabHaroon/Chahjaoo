//
//  NewsAdsViewModel.swift
//  Chaajao
//
//  Created by Ahmed Khan on 04/10/2021.
//

import Foundation
import Alamofire
class NewsAdsViewModel {
	var items: NewsAdsModel?

	var itemsUpdated:()->Void = {}

    func getData() {
        getNewsAdd()
		var watchIds = [String]()
//        for item in items {
//			watchIds.append("45")
//		}"
//		getThumbnailInfo(watchIds: ["45"])
	}

    func getNewsAdd() {
        HTTPServiceManager.request(requestName: NetworkClient.getAPIUrl(route: .newsAdd), parameters: nil, method: .get, showHud: true, delegate: self, otherData: nil, encoding: JSONEncoding.default, headers: NetworkClient.APP_HEADERS)
    }

//	func getThumbnailInfo(watchIds: [String]) {
//		getYoutubeData(watchIds: watchIds)  { (data) in
//			if let returnedItems = data["items"] as? [[String:Any]] {
//				for returnedItem in returnedItems {
//					if let watchId = returnedItem["id"] as? String {
//						if let modelIndex = self.items.firstIndex(where: {$0.watchId == watchId}) {
//							let url = (((returnedItem["snippet"] as! [String:Any])["thumbnails"] as! [String:Any])["medium"] as! [String:Any])["url"] as? String ?? ""
//							let title = (returnedItem["snippet"] as! [String:Any])["title"] as? String ?? ""
//							self.items[modelIndex].thumbnailUrl = url
//							self.items[modelIndex].title = title
//							self.itemsUpdated()
//						}
//					}
//				}
//			}
//		}
//	}
	
	func getYoutubeData(watchIds: [String],completion:((_ data: [String:Any])->())?) {
		HTTPServiceManager.request(requestName: getYoutubeVideoDataUrl(apiKey: YT_API_KEY, watchIds: watchIds), parameters: nil, showHud: false, method:.get,delegate:nil, otherData:nil, encoding: JSONEncoding.default).onSuccess { (httpRequest, data) in
			let dict:[String:Any] = data as! [String:Any]
			completion?(dict)
		}.onFailure { (httpRequest, error) in
			//MARK: TODO
            print(error.localizedDescription)
		}
	}
}

extension NewsAdsViewModel: HTTPRequestDelegate {
    
    func requestDidFailWithError(httpRequest: HTTPRequest, error: NSError) {
        print("FAILUREE: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
    func requestDidSucceedWithData(httpRequest: HTTPRequest, data: Any?) {
        print("SUCCEDDED")
        let dict:[String:Any] = data as! [String:Any]
        if((dict["isError"] != nil) == true) {
            Utility.showHudWithError(errorString: dict["responseException"] as? String ?? APIErrors.generic.rawValue)
        }
        else {
            if let result = dict["result"] as? [String:Any] {
                do {
                    items = try JSONDecoder().decode(NewsAdsModel.self, from: data as! Data)
                    itemsUpdated()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func requestDidFailWithInvalidSession(httpRequest: HTTPRequest, error: NSError) {
        print("INAVLID SESSIONS: " + error.localizedDescription)
        Utility.showHudWithError(errorString: error.localizedDescription)
    }
    
}
