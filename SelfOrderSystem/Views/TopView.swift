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
        ZStack {
            Image("topImage")
                .resizable()
                .scaledToFill()
                .blur(radius: 15)
                .ignoresSafeArea()
                .padding(0)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.3),
                    Color.green.opacity(0.1),
                    Color.white.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                Image("logo") // Replace with your asset
                    .resizable()
                    .scaleEffect(1.15)
                    .offset(x: 0, y: -19)
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                
                Text("ようこそ！") // Welcome to Self Order!
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                Spacer()
                
                Button(action: {
                    navigationPath.append(NavigationRoute.menu) // Navigate to Menu screen
                }) {
                    Text("注文を始める") // Start Order
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 60)
                        .background(Color.cusGreen)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                HStack {
                    Spacer()
                    Button {
                        print()
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .padding(.horizontal, 8)
                            Text("LANGUAGE")
                            Spacer()
                            Image(systemName: "chevron.down")
                                .padding(.horizontal, 8)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: Capsule())
                        .foregroundColor(.primary)
                        .font(.title)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1) // 軽い影
                    }
                    .frame(width: 300)
                }
                .padding(.trailing, 120)
                .padding(.bottom, 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea())
            .navigationBarHidden(true) // Hide navigation bar on the top screen
            
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: "globe") // 地球儀アイコン
                            .imageScale(.medium)
                        Text("JA") // 例: "JA", "EN"
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .foregroundColor(.primary)
                    .font(.caption.weight(.semibold))
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                }
            }
        }
    }
}

//#Preview {
//    TopView()
//}

#Preview {
    TopView(navigationPath: .constant(NavigationPath()))
        .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
