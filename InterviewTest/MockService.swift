//
//  MockService.swift
//  InterviewTest
//
//  Created by 呂紹瑜 on 2023/2/10.
//

import Foundation
import Combine

class MockService :  ServiceProtocal {

    var fetchNotificationListResult: AnyPublisher<NotificationList, Error>!
    
    func getNotificationList(firstOpen: Bool = false) -> AnyPublisher<NotificationList, Error> {
        fetchNotificationListResult
    }
    
    var fetchTotalBalanceResult: AnyPublisher<Double, Error>!
    func getTotalBalance(firstOpen: Bool, currency: Currency) -> AnyPublisher<Double, Error> {
        fetchTotalBalanceResult
    }
    
    var fetchFavoriteListResult: AnyPublisher<FavoriteList, Error>!
    func getFavoriteList(firstOpen: Bool) -> AnyPublisher<FavoriteList, Error> {
        fetchFavoriteListResult
    }
    
    var fetchBannerListResult: AnyPublisher<BannerList, Error>!
    func getAdBannerList() -> AnyPublisher<BannerList, Error> {
        fetchBannerListResult
    }
    

    
}
