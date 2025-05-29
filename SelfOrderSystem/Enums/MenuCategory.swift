//
//  MenuCategory.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Categories for the menu
enum MenuCategory: String, CaseIterable, Identifiable {
    case sandwich = "サンドイッチ"
    case side = "サイド"
    case drink = "ドリンク"
    var id: String { self.rawValue }
    
    var imageName: String {
        switch self {
        case .sandwich:
            return sampleMenuItems[0].imageName
        case .side:
            return sampleMenuItems[6].imageName
        case .drink:
            return drinkMenuItems[0].imageName
        }
    }
}
