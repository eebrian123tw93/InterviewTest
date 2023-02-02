//
//  HomeViewModel.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/1.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private var apiService: APIService!
    @Published var usdAccountBalance: Double = 0
    @Published var hkrAccountBalance: Double = 0
    @Published var hasNotice = false
    @Published var hiddenBalance = true
    @Published var refreshing = true
    @Published var favoriteModels: [FavoriteModel] = []
    @Published var bannerModels: [BannerModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        apiService = APIService()
        refresh()
    }
    
    func refresh(firstOpen: Bool = true) {
        
        let getUSDTotalBalance = apiService.getTotalBalance(firstOpen: firstOpen, currency: .usd).share()
        let getHKRTotalBalance = apiService.getTotalBalance(firstOpen: firstOpen, currency: .khr).share()
        
        let getNotificationList = apiService.getNotificationList(firstOpen: firstOpen)
            .map { !$0.models.filter { $0.status }.isEmpty }
        
        let getFavoriteList = apiService.getFavoriteList(firstOpen: firstOpen)
            .map { $0.models }.share()
        
        let getAdBannerList = apiService.getAdBannerList()
            .map { $0.models }.share()
        
        getUSDTotalBalance.sink(receiveValue: { [unowned self] totalBalance in
            self.usdAccountBalance = totalBalance
        }).store(in: &cancellables)
        
        getHKRTotalBalance.sink(receiveValue: { [unowned self] totalBalance in
            self.hkrAccountBalance = totalBalance
        }).store(in: &cancellables)
        
        getNotificationList
            .sink(receiveValue: { [unowned self] hasNotice in
                self.hasNotice = hasNotice
            }).store(in: &cancellables)
        
        getFavoriteList
            .sink(receiveValue: { [unowned self] models in
                self.favoriteModels = models
            }).store(in: &cancellables)
        
        getAdBannerList
            .sink(receiveValue: { [unowned self] models in
                self.bannerModels = models
            }).store(in: &cancellables)
        
        let totalBalance = Publishers.Zip(getUSDTotalBalance, getHKRTotalBalance).share()
        
        Publishers.Zip4(totalBalance, getNotificationList, getFavoriteList, getAdBannerList)
            .sink(receiveValue: { [unowned self] _ in
                self.refreshing = false
            }).store(in: &cancellables)
    }
    
    func reverseEyes() {
        hiddenBalance = !hiddenBalance
    }
}
