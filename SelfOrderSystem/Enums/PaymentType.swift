//
//  PaymentType.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Payment method types
enum PaymentType: String, CaseIterable, Identifiable {
    case cash = "現金"
    case qr = "QR決済"
    case creditCard = "クレジットカード"
    var id: String { self.rawValue }

    var iconName: String { // SF Symbol names for icons
        switch self {
        case .cash: return "dollarsign.circle.fill"
        case .qr: return "qrcode.viewfinder"
        case .creditCard: return "creditcard.fill"
        }
    }
}
