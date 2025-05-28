//
//  MenuItem.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Represents a single item on the menu
struct MenuItem: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String? = nil // Optional description
    let price: Double // Base price
    let imageName: String // Asset name for the item's image
    let category: MenuCategory
    var optionGroups: [MenuOptionGroup]? = nil // e.g., Size, Set choices, Drink choices
}
