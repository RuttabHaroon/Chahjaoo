//
//  NewsAddModel.swift
//  Chaajao
//
//  Created by Q.M.S on 30/12/2021.
//

struct NewsAdsModel: Codable {
    
    var message: String
    var result: [NewsResult]

}

struct NewsResult: Codable {
    var id: String
    var title: String
    var description: String
    var newsImage: String
    var link: String
    var createdDate: String
    var endDate: String
}
