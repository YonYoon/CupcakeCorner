//
//  Order.swift
//  CupcakeCorner
//
//  Created by Zhansen Zhalel on 29.12.2023.
//

import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _deliveryAddress = "deliveryAddress"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    struct DeliveryAddress: Codable {
        var name: String = ""
        var city: String = ""
        var street: String = ""
        var zip: String = ""
    }
    
    var deliveryAddress: DeliveryAddress {
        didSet {
            if let encoder = try? JSONEncoder().encode(deliveryAddress) {
                UserDefaults.standard.setValue(encoder, forKey: "DeliveryAddress")
            }
        }
    }
    
    var hasValidAddress: Bool {
        if deliveryAddress.name.hasNoLetters() || deliveryAddress.city.hasNoLetters() || deliveryAddress.street.hasNoLetters() || deliveryAddress.zip.hasNoLetters() {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1 per cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50 per cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    init() {
        if let savedAddress = UserDefaults.standard.data(forKey: "DeliveryAddress") {
            if let decodedAddress = try? JSONDecoder().decode(DeliveryAddress.self, from: savedAddress) {
                deliveryAddress = decodedAddress
                return
            }
        }
        
        deliveryAddress = DeliveryAddress()
    }
}

extension String {
    func hasNoLetters() -> Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
