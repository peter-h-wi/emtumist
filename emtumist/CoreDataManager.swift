//
//  CoreDataManager.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getAllItems() -> [ItemData] {
        let request: NSFetchRequest<ItemData> = ItemData.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func getItemById(id: NSManagedObjectID) -> ItemData? {
        do {
            return try viewContext.existingObject(with: id) as? ItemData
        } catch {
            return nil
        }
    }
    
    func deleteItem(item: ItemData) {
        viewContext.delete(item)
        save()
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ItemModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
            
        }
    }
}
