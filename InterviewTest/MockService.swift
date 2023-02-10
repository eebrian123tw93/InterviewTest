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
    

    
}
