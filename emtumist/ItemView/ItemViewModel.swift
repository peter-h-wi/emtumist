//
//  ItemViewModel.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import Foundation

final class ItemViewModel: ObservableObject {
    @Published var numberFormatter: NumberFormatter
    
    init() {
      numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .currency
      numberFormatter.maximumFractionDigits = 2
    }
}
