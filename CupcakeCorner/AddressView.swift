//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Zhansen Zhalel on 29.12.2023.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.deliveryAddress.name)
                TextField("City", text: $order.deliveryAddress.city)
                TextField("Street", text: $order.deliveryAddress.street)
                TextField("Zip", text: $order.deliveryAddress.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
