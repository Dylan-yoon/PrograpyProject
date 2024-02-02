//
//  CoreDataManager.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func fetchData(_ id: String? = nil) -> Result<[BookmarkData], CoreDataError> {
        
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return .failure(.defaultError)
        }
        
        do {
            let result = try context.fetch(Bookmark.fetchRequest())
            let data = result.compactMap {
                BookmarkData(detail: $0.detail, id: $0.id, url: $0.url)
            }
            
            return .success(data)
        } catch {
            print(error.localizedDescription)
        }
        
        return .failure(.defaultError)
    }
    
    func saveData(_ bookmarkData: BookmarkData, completion: @escaping () -> Void) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.defaultError
        }
        let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context)
        
        if let entity = entity {
            let info = NSManagedObject(entity: entity, insertInto: context)
            info.setValue(bookmarkData.detail, forKey: "detail")
            info.setValue(bookmarkData.id, forKey: "id")
            info.setValue(bookmarkData.url, forKey: "url")
            do {
                try context.save()
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(_ bookmarkData: BookmarkData?) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.defaultError
        }
        
        guard let bookmarkData = bookmarkData else {
            throw CoreDataError.defaultError
        }
        
        guard let id = bookmarkData.id else {
            throw CoreDataError.defaultError
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let updatingData = test[0] as? NSManagedObject else { return }
            
            updatingData.setValue(bookmarkData.detail, forKey: "detail")
            updatingData.setValue(bookmarkData.id, forKey: "id")
            updatingData.setValue(bookmarkData.url, forKey: "url")
            
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteDate(id: String) throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.defaultError
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Bookmark")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let test = try context.fetch(fetchRequest)
            guard let objectDelete = test[0] as? NSManagedObject else { return }
            
            context.delete(objectDelete)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllData() throws {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            throw CoreDataError.defaultError
        }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookmark")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        try context.execute(deleteRequest)
        try context.save()
    }
}

enum CoreDataError: Error {
    case defaultError
}

struct BookmarkData {
    let detail: String?
    let id: String?
    let url: String?
}
