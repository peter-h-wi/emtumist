//
//  AddView.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import SwiftUI

struct AddView: View {
    @State private var name: String = ""
    @State private var expectedPrice: Double = 0.0
    private let numberFormatter = NumberFormatter()
    
    var body: some View {
        ScrollView {
            
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
