//
//  DataManager.swift
//  iOS-Module
//
//  Created by 이영호 on 9/23/24.
//

import Foundation

public class DataManager<T: Codable> {
    
    private let itemsKey = "sample"
    
    public init() {}
    
    // 데이터를 저장하는 함수
    public func saveItem(_ items: [T]) {
        let encoder = JSONEncoder()
        
        // JSON 인코딩이 잘 되었는지 확인
        if let encodedData = try? encoder.encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
            print("Items saved successfully.")
        } else {
            print("Failed to encode items.")
        }
        
        // 저장된 데이터 확인
        if let savedData = UserDefaults.standard.data(forKey: itemsKey) {
            print("Saved data exists in UserDefaults: \(savedData)")
        } else {
            print("No data found in UserDefaults for key: \(itemsKey)")
        }
    }
    
    // 데이터를 로드하는 함수
    public func loadItem() -> [T] {
        if let saveData = UserDefaults.standard.data(forKey: itemsKey) {
            print("Saved data exists in UserDefaults: \(saveData)")
            
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode([T].self, from: saveData) {
                print("Decoded items: \(decodedItems)")
                return decodedItems
            } else {
                print("Failed to decode saved data.")
            }
        } else {
            print("No data found in UserDefaults for key: \(itemsKey)")
        }
        
        return []
    }
}
