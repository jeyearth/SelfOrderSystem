//
//  NavigationRoute.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import Foundation

// Defines the possible destinations in our navigation stack
enum NavigationRoute: Hashable {
    case menu
    case paymentMethodSelection
    case waitingForPayment(selectedPaymentType: PaymentType)
    case paymentComplete
}
