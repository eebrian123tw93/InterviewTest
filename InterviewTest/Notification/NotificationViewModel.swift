//
//  NotificationViewModel.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    private var apiService: APIService!
    @Published var notificationModels: [NotificationModel] = []
    @Published var refreshing = true
    private var cancellables: Set<AnyCancellable> = []
    init() {
        apiService = APIService()
        getNotificationList()
    }
    
    func refresh() {
       getNotificationList()
    }
    
    func getNotificationList() {
        apiService.getNotificationList()
            .sink(receiveValue: { [unowned self] listModel in
                self.notificationModels = listModel.models
                self.refreshing = false
            }).store(in: &cancellables)
    }
    
}


