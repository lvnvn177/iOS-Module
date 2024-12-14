//
//  File.swift
//  
//
//  Created by 이영호 on 12/13/24.
//

import CoreData
import Foundation

public class CoreDataManager {
    public static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        // "WeatherApp"은 Core Data 모델 파일(.xcdatamodeld)의 이름과 일치해야 합니다.
        persistentContainer = NSPersistentContainer(name: "WeatherApp")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data stack: \(error)")
            }
        }
    }
    
    // 데이터를 저장하는 함수
    public func saveItem<T: NSManagedObject>(_ item: T) {
        let context = persistentContainer.viewContext
        context.insert(item)
        
        do {
            try context.save()
        } catch {
            print("Failed to save item: \(error)")
        }
    }
    
    // 데이터를 로드하는 함수
    public func fetchItems<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = T.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    // 데이터를 삭제하는 함수
    public func deleteItem<T: NSManagedObject>(_ item: T) {
        let context = persistentContainer.viewContext
        context.delete(item)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
}
