//
//  APIService.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/1.
//

import Foundation
import Combine

class APIService :  NSObject {
    
    func request(urlString: String) -> AnyPublisher<JsonResultModel, Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: JsonResultModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getNotificationList(firstOpen: Bool = false) -> AnyPublisher<NotificationList, Error> {
        var urlString: String
        if firstOpen {
            urlString = "https://willywu0201.github.io/data/emptyNotificationList.json"
        } else {
            urlString = "https://willywu0201.github.io/data/notificationList.json"
        }
        return request(urlString: urlString).tryMap { result in
            let dataDict = try result.dataDictionary()
            if dataDict.isEmpty {
                return NotificationList(models: [])
            } else {
                return try dataDict.dencode(NotificationList.self)
            }
        }.eraseToAnyPublisher()
    }
    
    
    func getSavingList(firstOpen: Bool, currency: Currency) -> AnyPublisher<SavingsList, Error> {
        var urlString: String
        switch (firstOpen, currency) {
        case (true, .usd):
            urlString = "https://willywu0201.github.io/data/usdSavings1.json"
        case (true, .khr):
            urlString = "https://willywu0201.github.io/data/khrSavings1.json"
        case (false, .usd):
            urlString = "https://willywu0201.github.io/data/usdSavings2.json"
        case (false, .khr):
            urlString = "https://willywu0201.github.io/data/khrSavings2.json"
        }
        return request(urlString: urlString).tryMap {
            try $0.dataDictionary().dencode(SavingsList.self)
        }.eraseToAnyPublisher()
    }
    
    func getFixedDepositList(firstOpen: Bool, currency: Currency) -> AnyPublisher<FixedDepositList, Error> {
        var urlString: String
        switch (firstOpen, currency) {
        case (true, .usd):
            urlString = "https://willywu0201.github.io/data/usdFixed1.json"
        case (true, .khr):
            urlString = "https://willywu0201.github.io/data/khrFixed1.json"
        case (false, .usd):
            urlString = "https://willywu0201.github.io/data/usdFixed2.json"
        case (false, .khr):
            urlString = "https://willywu0201.github.io/data/khrFixed2.json"
        }
        return request(urlString: urlString).tryMap {
            try $0.dataDictionary().dencode(FixedDepositList.self)
        }.eraseToAnyPublisher()
    }
    
    func getDigitalList(firstOpen: Bool, currency: Currency) -> AnyPublisher<DigitalList, Error> {
        var urlString: String
        switch (firstOpen, currency) {
        case (true, .usd):
            urlString = "https://willywu0201.github.io/data/usdDigital1.json"
        case (true, .khr):
            urlString = "https://willywu0201.github.io/data/khrDigital1.json"
        case (false, .usd):
            urlString = "https://willywu0201.github.io/data/usdDigital2.json"
        case (false, .khr):
            urlString = "https://willywu0201.github.io/data/khrDigital1.json"
        }
        return request(urlString: urlString).tryMap {
            try $0.dataDictionary().dencode(DigitalList.self)
        }.eraseToAnyPublisher()
    }
    
    func getTotalBalance(firstOpen: Bool, currency: Currency) -> AnyPublisher<Double, Error> {
        Publishers.Zip3(getSavingList(firstOpen: firstOpen, currency: currency),
                        getFixedDepositList(firstOpen: firstOpen, currency: currency),
                        getDigitalList(firstOpen: firstOpen, currency: currency))
        .map { savingList, fixedDepositList, digitalList in
            let savingBalance = savingList.models.map(\.balance).reduce(0.0, +)
            let fixedDepositBalance = fixedDepositList.models.map(\.balance).reduce(0.0, +)
            let digitalBalance = digitalList.models.map(\.balance).reduce(0.0, +)
            let totalBalance = savingBalance + fixedDepositBalance + digitalBalance
            return totalBalance
        }.eraseToAnyPublisher()
    }
    
    func getFavoriteList(firstOpen: Bool = false) -> AnyPublisher<FavoriteList, Error>  {
        var urlString: String
        if firstOpen {
            urlString = "https://willywu0201.github.io/data/emptyFavoriteList.json"
        } else {
            urlString = "https://willywu0201.github.io/data/favoriteList.json"
        }
        return request(urlString: urlString).tryMap { result in
            let dataDict = try result.dataDictionary()
            if dataDict.isEmpty {
                return FavoriteList(models: [])
            } else {
                return try dataDict.dencode(FavoriteList.self)
            }
        }.eraseToAnyPublisher()
    }
    
    func getAdBannerList() -> AnyPublisher<BannerList, Error>  {
        let urlString = "https://willywu0201.github.io/data/banner.json"
        return request(urlString: urlString).tryMap {
            try $0.dataDictionary().dencode(BannerList.self)
        }.eraseToAnyPublisher()
    }
    
}
