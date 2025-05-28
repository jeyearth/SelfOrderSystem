//
//  TopView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// MARK: - Screen Views

// 1. Top Screen (トップ画面)
struct TopView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            // Placeholder for your app's logo or main image
            Image("your_app_logo_placeholder") // Replace with your asset
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 10)
                .accessibilityLabel("App Logo")


            Text("セルフオーダーへようこそ！") // Welcome to Self Order!
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)

            Spacer()

            Button(action: {
                navigationPath.append(NavigationRoute.menu) // Navigate to Menu screen
            }) {
                Text("注文を始める") // Start Order
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 60)
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationBarHidden(true) // Hide navigation bar on the top screen
    }
}

//#Preview {
//    TopView()
//}

#Preview {
    TopView(navigationPath: .constant(NavigationPath()))
         .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
