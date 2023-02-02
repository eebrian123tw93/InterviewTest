//
//  CodableExtenstion.swift
//  Demo
//
//  Created by 呂紹瑜 on 2023/2/1.
//
import UIKit
import CoreData

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    
    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()
        if self.allKeys.count == 0 {
            return dictionary
        }
        for key in self.allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }

    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []
        while self.isAtEnd == false {
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Int64.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

extension KeyedEncodingContainer {
    mutating func encode(_ value: [String: Any], forKey key: K) throws {
        var container = nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        
        for (key, data) in value {
            guard let keyCoding = JSONCodingKeys(stringValue: key) else {continue}
            
            if let data2 = data as? Bool {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? String {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Int {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Double {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Dictionary<String, Any> {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Array<Any> {
                // run KeyedEncodingContainer > func encode(_ value: [Any], forKey key: K) throws
                // #Gevin_note: 如果空 array，裡面沒有值，那程式就沒辦法依裡面的資料來判斷 Array 是屬於什麼 type，最後會造成問題
                try container.encode(data2, forKey: keyCoding)
            }
        }
    }
    
    // [String:Any] 裡的 Array
    mutating func encode(_ value: [Any], forKey key: K) throws {
        var arrayContainer = nestedUnkeyedContainer(forKey: key)
        for data in value {
            if let data2 = data as? Bool {
                try arrayContainer.encode(data2)
            } else if let data2 = data as? String {
                try arrayContainer.encode(data2)
            } else if let data2 = data as? Int {
                try arrayContainer.encode(data2)
            } else if let data2 = data as? Double {
                try arrayContainer.encode(data2)
            } else if let data2 = data as? Dictionary<String, Any> {
                // run UnkeyedEncodingContainer > func encode(_ value: [String: Any] ) throws {
                try arrayContainer.encode(data2)
            } else if let data2 = data as? Array<Any> {
                // run 下面 array 裡的 array
                try arrayContainer.encode(data2)
            }
        }
    }

}

extension UnkeyedEncodingContainer {
    
    // array 裡的 array
    mutating func encode(_ value: [Any] ) throws {
        var container = nestedUnkeyedContainer()

        for data in value {
            if let data2 = data as? Bool {
                try container.encode(data2)
            } else if let data2 = data as? String {
                try container.encode(data2)
            } else if let data2 = data as? Int {
                try container.encode(data2)
            } else if let data2 = data as? Double {
                try container.encode(data2)
            } else if let data2 = data as? Dictionary<String, Any> {
                // run UnkeyedEncodingContainer > func encode(_ value: [String: Any] ) throws {
                try container.encode(data2)
            } else if let data2 = data as? Array<Any> {
                try container.encode(data2)
            }
        }
    }
    
    // array 裡的 [String: Any]
    mutating func encode(_ value: [String: Any] ) throws {
        
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        
        for (key, data) in value {
            guard let keyCoding = JSONCodingKeys(stringValue: key) else {continue}
            
            if let data2 = data as? Bool {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? String {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Int {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Double {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Dictionary<String, Any> {
                try container.encode(data2, forKey: keyCoding)
            } else if let data2 = data as? Array<Any> {
                // run KeyedEncodingContainer > func encode(_ value: [Any], forKey key: K) throws
                try container.encode(data2, forKey: keyCoding)
            }
        }
    }
}
