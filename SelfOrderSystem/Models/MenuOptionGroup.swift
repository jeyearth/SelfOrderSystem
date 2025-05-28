//
//  MenuOptionGroup.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Represents a group of selectable options for a menu item
struct MenuOptionGroup: Identifiable, Equatable {
    static func == (lhs: MenuOptionGroup, rhs: MenuOptionGroup) -> Bool {
        lhs.id == rhs.id // Equatable based on ID
    }
    let id = UUID()
    let name: String // e.g., "セット選択" (Set Choice), "ドリンク" (Drink)
    let options: [MenuOption]
    let allowsMultipleSelection: Bool = false // Default to single choice per group
}
