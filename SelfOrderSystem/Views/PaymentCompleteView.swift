//
//  PaymentCompleteView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// 5. Payment Complete Screen (支払い完了画面)
struct PaymentCompleteView: View {
    let onReturnToTop: () -> Void // Callback to navigate back to the top

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(Color.cusGreen)

            Text("お支払い完了") // Payment Complete
                .font(.system(size: 48, weight: .bold, design: .rounded))

            Text("ご注文ありがとうございました！") // Thank you for your order!
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
            Spacer()

            Button(action: onReturnToTop) {
                Text("トップに戻る") // Return to Top
                    .font(.title.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 60)
                    .background(Color.cusGreen) // Or your app's primary color
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true) // No navigation bar on this final screen
    }
}

#Preview {
    PaymentCompleteView(onReturnToTop: {
        print("トップに戻るボタンが押されました！")
    })
}
