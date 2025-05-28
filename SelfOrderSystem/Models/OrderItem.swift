//
//  OrderItem.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Represents an item added to the order
struct OrderItem: Identifiable {
    let id = UUID()
    var menuItem: MenuItem
    var quantity: Int
    var selectedOptions: [MenuOption] = [] // Options chosen for this item

    // Calculates the total price for this order item including options
    var totalPrice: Double {
        let basePrice = menuItem.price
        let optionsPrice = selectedOptions.reduce(0) { $0 + $1.additionalPrice }
        return (basePrice + optionsPrice) * Double(quantity)
    }
}
