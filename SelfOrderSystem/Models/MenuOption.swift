//
//  MenuOption.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Represents a single choice within an option group
struct MenuOption: Identifiable, Equatable, Hashable { // Hashable for Picker
    let id = UUID()
    let name: String // e.g., "単品" (Single Item), "コカ・コーラ"
    let additionalPrice: Double // Price added to the base item price
    var imageName: String? = nil
}
