//
//  JsonResult.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/1.
//

import Foundation

enum CustomError: Error {
    case invlidURL
    case responseNoData
    case payloadIsNotDictionary
    case payloadIsNil
    case resultIsNil
    case responseJsonParseFail
    case decodeError
}

struct JsonResultModel: Decodable {
    let msgCode: String
    let msgContent: String
    let result: Any?
    enum CodingKeys: String, CodingKey {
        case msgCode = "msgCode"
        case msgContent = "msgContent"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        msgContent = try container.decodeIfPresent(String.self, forKey: .msgContent) ?? ""
        msgCode = try container.decodeIfPresent(String.self, forKey: .msgCode) ?? ""
        if let dict = try container.decodeIfPresent([String: Any].self, forKey: .result) {
            result = dict
        } else if let array = try container.decodeIfPresent([Any].self, forKey: .result) {
            result = array
        } else {
            result = nil
        }
    }

    func dataDictionary()  throws -> [String: Any] {
        guard let result = self.result as? [String: Any] else {
            throw CustomError.payloadIsNotDictionary
        }
        return result
    }

    func mapTo<T: Decodable>(type: T.Type) throws -> T {
        guard let result = result else {
            throw CustomError.payloadIsNil
        }
        let data = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let model = try decoder.decode(type, from: data)
        return model
    }

}
