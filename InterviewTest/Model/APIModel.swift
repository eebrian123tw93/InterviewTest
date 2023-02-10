//
//  APIModel.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import Foundation

enum Currency {
    case usd
    case khr
}

enum FavoriteType: String {
    case cube = "CUBC"
    case mobile = "Mobile"
    case pmf = "PMF"
    case creditCard = "CreditCard"
}

struct NotificationList: Codable {
    let models: [NotificationModel]
    
    enum CodingKeys: String, CodingKey {
        case models = "messages"
        
    }
}

struct NotificationModel: Codable {
    let status: Bool
    let updateDateTime: String
    let title: String
    let message: String
}

struct SavingsList: Codable {
    let models: [BalanceModel]
    enum CodingKeys: String, CodingKey {
        case models = "savingsList"
    }
}

struct FixedDepositList: Codable {
    let models: [BalanceModel]
    enum CodingKeys: String, CodingKey {
        case models = "fixedDepositList"
    }
}

struct DigitalList: Codable {
    let models: [BalanceModel]
    enum CodingKeys: String, CodingKey {
        case models = "digitalList"
    }
}

struct BalanceModel: Codable {
    let account, curr: String
    let balance: Double
}

struct FavoriteList: Codable {
    let models: [FavoriteModel]
    enum CodingKeys: String, CodingKey {
        case models = "favoriteList"
        
    }
}

struct FavoriteModel: Codable {
    let nickname, transType: String
}

struct BannerList: Codable {
    let models: [BannerModel]
    enum CodingKeys: String, CodingKey {
        case models = "bannerList"
    }
}

struct BannerModel: Codable {
    let adSeqNo: Int
    let linkURL: String
    
    enum CodingKeys: String, CodingKey {
        case adSeqNo
        case linkURL = "linkUrl"
    }
}
