//
//  MainViewModel.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import Foundation
import CoreData

final class MainViewModel: ObservableObject {
    // main list
    @Published var items : [ItemModel] = []
    @Published var sumExpected: Double = 0.0
    @Published var sumActual: Double = 0.0
    @Published var difference: Double = 0.0
    
    // add sheet
    @Published var isShowingAddSheet = false
    @Published var newName: String = ""
    @Published var newExpectedPrice: Double = 0.0
    
    // change sheet
    @Published var isShowingUpdateSheet = false
    @Published var modifiedActualPrice: Double = 0.0

    // reset
    @Published var isShowingResetAlert = false
    
    @Published var formatter = NumberFormatter()
    
    init() {
        formatter.numberStyle = .currency
    }
    
    func addItem() {
        if (isShowingAddSheet) {
            guard newName != "" else {
                return
            }
            guard newExpectedPrice != 0.0 else {
                return
            }
            let itemData = ItemData(context: CoreDataManager.shared.viewContext)
            itemData.name = newName
            itemData.expectedPrice = newExpectedPrice
            itemData.actualPrice = 0
            CoreDataManager.shared.save()
            newName = ""
            newExpectedPrice = 0.0
            updateSum()
        }
    }

    func fetchAllItems() {
        items = CoreDataManager.shared.getAllItems().map(ItemModel.init)
        updateSum()
    }
    
    func updateActualPrice(of itm: ItemModel) {
        let existingItem = CoreDataManager.shared.getItemById(id: itm.id)
        if let existingItem = existingItem {
            existingItem.actualPrice = modifiedActualPrice
            CoreDataManager.shared.save()
            updateSum()
        }
    }
    
    func toggleCheck(of itm: ItemModel) {
        let existingItem = CoreDataManager.shared.getItemById(id: itm.id)
        if let existingItem = existingItem {
            existingItem.isChecked.toggle()
            CoreDataManager.shared.save()
        }
    }
    
    func delete(_ itm: ItemModel) {
        let existingItem = CoreDataManager.shared.getItemById(id: itm.id)
        if let existingItem = existingItem {
            CoreDataManager.shared.deleteItem(item: existingItem)
            updateSum()
        }
    }
    
    func updateSum() {
        sumExpected = 0
        sumActual = 0
        for item in items {
            sumExpected += item.expectedPrice
            sumActual += item.actualPrice
        }
        difference = sumExpected - sumActual
    }
    
    func getExSum() -> String {
        return formatter.string(from: NSNumber(value: sumExpected)) ?? "$0"
    }
    
    func getAcSum() -> String {
        return formatter.string(from: NSNumber(value: sumActual)) ?? "$0"
    }
    
    func getDiff() -> String {
        return formatter.string(from: NSNumber(value: difference)) ?? "$0"
    }
    
    func totalReset() {
        if (isShowingResetAlert) {
            for itm in items {
                delete(itm)
            }
        }
    }
}
