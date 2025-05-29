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
    
    @State private var totalAmount: Double = 1400

    var body: some View {
        VStack {
            VStack(spacing: 25) {
                Text("お支払い方法を選択") // Select Payment Method
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 40)
                
                (Text("合計金額: ¥ ")
                    .font(.system(size: 30, weight: .semibold))
                 + Text("\(Int(order.totalAmount))")
                    .font(.system(size: 80, weight: .bold))
                )
                .contentTransition(.numericText(value: order.totalAmount))
                .padding(.horizontal)
                
                HStack(spacing: 40) {
                    ForEach(PaymentType.allCases) { type in
                        Button(action: {
                            navigationPath.append(NavigationRoute.waitingForPayment(selectedPaymentType: type))
                        }) {
                            VStack(spacing: 15) {
                                Spacer()
                                Image(systemName: type.iconName)
                                    .font(.system(size: 120))
                                Spacer()
                                Text(type.rawValue)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxHeight: 320)
                            .frame(maxWidth: 300)
                            .background(Color.green) // Use your app's accent color
                            .cornerRadius(12)
                            .shadow(radius: 3)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: 940, maxHeight: .infinity)
//            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
//            .navigationTitle("お支払い方法") // Payment Method
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { navigationPath.removeLast() } label: { // Go back to Menu
                        Image(systemName: "chevron.left")
                        Text("メニューに戻る")
                    }
                    .foregroundColor(.cusGreen)
                    .font(.title.bold())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    PaymentMethodSelectionView(navigationPath: .constant(NavigationPath()))
        .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
