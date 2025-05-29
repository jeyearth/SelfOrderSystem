//
//  Order.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Manages the current order (list of items and total price)
class Order: ObservableObject {
    @Published var items: [OrderItem] = []

    var totalAmount: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    // Adds an item to the order or updates its quantity if already present with same options
    func add(menuItem: MenuItem, quantity: Int = 1, selectedOptions: [MenuOption] = []) {
        // Check if an identical item (same ID and same selected options) exists
        if let index = items.firstIndex(where: { $0.menuItem.id == menuItem.id && $0.selectedOptions.elementsEqual(selectedOptions, by: { $0.id == $1.id }) }) {
            items[index].quantity += quantity
        } else {
            let newOrderItem = OrderItem(menuItem: menuItem, quantity: quantity, selectedOptions: selectedOptions)
            items.append(newOrderItem)
        }
    }

//    func removeItem(at offsets: IndexSet) {
//        items.remove(atOffsets: offsets)
//    }
    
    func removeItem(id: UUID) {
        items.removeAll { $0.id == id }
    }

    func clearOrder() {
        items.removeAll()
    }
}
