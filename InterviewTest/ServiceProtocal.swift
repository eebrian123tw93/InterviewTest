//
//  ServiceProtocal.swift
//  InterviewTest
//
//  Created by 呂紹瑜 on 2023/2/10.
//

import Foundation
import Combine

protocol ServiceProtocal {
    func getNotificationList(firstOpen: Bool) -> AnyPublisher<NotificationList, Error>
}
