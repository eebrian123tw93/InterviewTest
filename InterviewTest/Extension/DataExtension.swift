//
//  DataExtension.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/2.
//

import Foundation
extension Data {
    func mapToJson() throws -> [String: Any] {
        let data = self
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            throw error
        }
        // 回應的資料無法轉成 json
        guard let dict = json as? [String: Any] else {
            throw CustomError.responseJsonParseFail
        }
        return dict
    }
}
