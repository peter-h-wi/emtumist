//
//  ItemModel.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import Foundation
import CoreData

struct ItemModel {
    let itemData: ItemData
    
    var id: NSManagedObjectID {
        return itemData.objectID
    }
    
    var name: String {
        return itemData.name ?? ""
    }
    
    var count: Int {
        return Int(itemData.count)
    }
    
    var isChecked: Bool {
        return itemData.isChecked
    }
    
    var expectedPrice: Double {
        return itemData.expectedPrice
    }
    
    var actualPrice: Double {
        return itemData.actualPrice
    }
}
