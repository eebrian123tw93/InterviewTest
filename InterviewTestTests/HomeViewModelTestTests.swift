//
//  HomeViewModelTestTests.swift
//  InterviewTestTests
//
//  Created by 呂紹瑜 on 2023/2/10.
//

import XCTest
import Combine

final class HomeViewModelTestTests: XCTestCase {
    
    private var mockService: MockService!
    private var viewModel: HomeViewModel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockService = MockService()
        viewModel = HomeViewModel(apiService: mockService)
    }
    
    override func tearDownWithError() throws {
       mockService = nil
        viewModel = nil
    }
    
    func testGetBannerList() throws {
    
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure { () in
            do {
                
            } catch {
                
            }
          
        }
    }

}
