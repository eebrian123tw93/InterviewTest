//
//  NotificationViewModelTestTests.swift
//  InterviewTestTests
//
//  Created by 呂紹瑜 on 2023/2/10.
//

import XCTest
import Combine

final class NotificationViewModelTestTests: XCTestCase {
    
    private var mockService: MockService!
    private var viewModel: NotificationViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockService = MockService()
        viewModel = NotificationViewModel(apiService: mockService)
    }
    
    override func tearDownWithError() throws {
       mockService = nil
        viewModel = nil
    }
    
    func testGetNotificationList() throws {
        let notifiacationList = NotificationList(models: [NotificationModel(status: true, updateDateTime: "", title: "", message: "")])
        let expectation = XCTestExpectation(description: "State is set to populated")
        
        viewModel.$notificationModels.dropFirst().sink { models in
            XCTAssertGreaterThan(models.count, 0)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        mockService.fetchNotificationListResult = Result.success(notifiacationList).publisher.eraseToAnyPublisher()
        viewModel.getNotificationList()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure { () in
            do {
                try testGetNotificationList()
            } catch {
                
            }
          
        }
    }
    
}
