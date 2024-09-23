//
//  DataManager.swift
//  iOS-Module
//
//  Created by 이영호 on 9/23/24.
//

import Foundation

class DataManager<T: Codable> {
    
    private let itemsKey = "sample"
    
    init() {}
    
    // 데이터를 저장하는 함수
    public func saveItem(_ items: [T]) {
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    // 데이터를 로드하는 함수
    public func loadItem() -> [T] {
        if let saveData = UserDefaults.standard.data(forKey: itemsKey) {
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([T].self, from: saveData) {
                return decodedItems
            }
        }
        
        return []
    }
}
