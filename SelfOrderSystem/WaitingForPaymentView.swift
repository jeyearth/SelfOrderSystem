//
//  WaitingForPaymentView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// 4. Waiting for Payment Screen (支払い待ち画面)
struct WaitingForPaymentView: View {
    @Binding var navigationPath: NavigationPath
    let paymentType: PaymentType
    let orderTotal: Double

    @State private var countdown: Int = 3 // Timer for simulated processing
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            Text("お支払い: \(paymentType.rawValue)") // Payment: [Method]
                .font(.largeTitle.weight(.bold))
                .padding(.top, 40)

            Text("合計: ¥\(Int(orderTotal))")
                .font(.title.weight(.semibold))

            Spacer()

            Group { // Content specific to payment type
                switch paymentType {
                case .cash:
                    Image(systemName: "banknote.fill")
                        .resizable().scaledToFit().frame(width:120, height:120)
                        .foregroundColor(.green)
                    Text("レジで係員に現金をお渡しください。") // Please pay cash to the staff.
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    Text("お支払い後、「完了」ボタンを押してください。") // Press "Complete" after payment.
                        .font(.headline)
                        .foregroundColor(.secondary)
                case .qr:
                    Image(systemName: "qrcode")
                        .resizable().scaledToFit().frame(width:180, height:180)
                    Text("表示されたQRコードをスキャンしてください。") // Scan the displayed QR code.
                        .font(.title2)
                        .multilineTextAlignment(.center)
                case .creditCard:
                    Image(systemName: "creditcard.and.123")
                        .resizable().scaledToFit().frame(width:150, height:150)
                        .foregroundColor(.blue)
                    Text("クレジットカードを端末にかざしてください。") // Tap your credit card on the terminal.
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 20)


            if paymentType != .cash {
                 ProgressView()
                     .scaleEffect(1.8)
                     .padding()
                 Text("支払い処理中... しばらくお待ちください \(countdown > 0 ? "(\(countdown))" : "")") // Processing payment...
                     .font(.headline)
                     .onReceive(timer) { _ in
                         if countdown > 0 {
                             countdown -= 1
                         } else {
                             timer.upstream.connect().cancel() // Stop timer
                             navigationPath.append(NavigationRoute.paymentComplete) // Move to complete screen
                         }
                     }
            } else { // For cash payment, provide a manual completion button
                 Button(action: {
                     navigationPath.append(NavigationRoute.paymentComplete)
                 }) {
                     Text("支払い完了を確認") // Confirm Payment Complete
                         .font(.title2.weight(.semibold))
                         .foregroundColor(.white)
                         .padding()
                         .frame(maxWidth: 300)
                         .background(.cusGreen)
                         .cornerRadius(10)
                 }
                 .padding(.top, 20)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("支払い処理") // Processing Payment
        .navigationBarBackButtonHidden(true) // Usually, users shouldn't go back from here easily
        .toolbar {
             ToolbarItem(placement: .navigationBarLeading) {
                 // Allow going back to change method ONLY if it's a manual step like cash
                 if paymentType == .cash {
                     Button { navigationPath.removeLast() } label: {
                         Image(systemName: "chevron.left")
                         Text("方法変更") // Change Method
                     }
                     .foregroundColor(.cusGreen)
                     .font(.title.bold())
                 }
             }
         }
    }
}

//#Preview {
//    WaitingForPaymentView()
//}

