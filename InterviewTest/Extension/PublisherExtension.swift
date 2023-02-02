//
//  PublisherExtension.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import Combine

extension Publisher where Self.Failure == Error {
    public func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: receiveValue)
    }
}
