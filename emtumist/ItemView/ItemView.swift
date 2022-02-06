//
//  ItemView.swift
//  emtumist
//
//  Created by peter wi on 2/5/22.
//

import SwiftUI

struct ItemView: View {
    let itm: ItemModel
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "circle")
                    .foregroundColor(.primary)
            }
            VStack(alignment: .leading) {
                Text(itm.name)
                    .foregroundColor(.primary)
                HStack {
                    Text("expect: $\(itm.expectedPrice)")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("actual: $\(itm.expectedPrice)")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
