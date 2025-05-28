//
//  PaymentMethodSelectionView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// 3. Payment Method Selection Screen (支払い方法選択画面)
struct PaymentMethodSelectionView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var order: Order

    var body: some View {
        VStack(spacing: 25) {
            Text("お支払い方法を選択") // Select Payment Method
                .font(.largeTitle.weight(.bold))
                .padding(.top, 40)

            Text("合計金額: ¥\(Int(order.totalAmount))") // Total Amount
                .font(.title.weight(.semibold))
                .padding(.bottom, 30)

            ForEach(PaymentType.allCases) { type in
                Button(action: {
                    navigationPath.append(NavigationRoute.waitingForPayment(selectedPaymentType: type))
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: type.iconName)
                            .font(.title)
                            .frame(width: 30)
                        Text(type.rawValue)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 350)
                    .background(Color.orange) // Use your app's accent color
                    .cornerRadius(12)
                    .shadow(radius: 3)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("お支払い方法") // Payment Method
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
             ToolbarItem(placement: .navigationBarLeading) {
                 Button { navigationPath.removeLast() } label: { // Go back to Menu
                     Image(systemName: "chevron.left")
                     Text("メニューに戻る")
                 }
             }
         }
    }
}

#Preview {
    PaymentMethodSelectionView(navigationPath: .constant(NavigationPath()))
         .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
