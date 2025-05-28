//
//  ContentView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// MARK: - Root View with Navigation Stack
struct ContentView: View {
    @StateObject private var order = Order() // Manages the order state
    @State private var navigationPath = NavigationPath() // Manages the navigation stack

    var body: some View {
        NavigationStack(path: $navigationPath) {
            // The first view in the navigation stack
            TopView(navigationPath: $navigationPath)
                // Define destinations for each route
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .menu:
                        MenuView(navigationPath: $navigationPath)
                    case .paymentMethodSelection:
                        PaymentMethodSelectionView(navigationPath: $navigationPath)
                    case .waitingForPayment(let selectedType):
                        WaitingForPaymentView(navigationPath: $navigationPath, paymentType: selectedType, orderTotal: order.totalAmount)
                    case .paymentComplete:
                        PaymentCompleteView(
                            onReturnToTop: {
                                order.clearOrder() // Clear the current order
                                navigationPath.removeLast(navigationPath.count) // Pop all views to return to TopView
                            }
                        )
                    }
                }
        }
        .environmentObject(order) // Make the order accessible to all child views
        .accentColor(.orange) // Example global accent color
    }
}


#Preview {
    ContentView()
//        .previewDevice("iPad Pro (11-inch) (4th generation)") // Preview as an iPad
        .environmentObject(Order()) // Provide a dummy order for the preview
}

#Preview {
    MenuView(navigationPath: .constant(NavigationPath()))
         .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
