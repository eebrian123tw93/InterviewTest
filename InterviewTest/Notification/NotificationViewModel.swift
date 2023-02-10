//
//  NotificationViewModel.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    private var apiService: ServiceProtocal!
    @Published var notificationModels: [NotificationModel] = []
    @Published var refreshing = true
    private var cancellables: Set<AnyCancellable> = []
    
    convenience init() {
        self.init(apiService: APIService())
    }
    
    init(apiService: ServiceProtocal) {
        self.apiService = apiService
    }
    
    func refresh() {
       getNotificationList()
    }
    
    func getNotificationList() {
        apiService.getNotificationList(firstOpen: false)
            .sink(receiveValue: { [unowned self] listModel in
                self.notificationModels = listModel.models
                self.refreshing = false
            }).store(in: &cancellables)
    }
    
}


