//
//  MenuItemViewCell.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// View for a single menu item in the grid
struct MenuItemViewCell: View {
    let item: MenuItem
    
    @Binding var showingItemDetailSheet: MenuItem?

    var body: some View {
        VStack {
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .frame(width: 220)
                .padding(.bottom)
                .shadow(radius: 4)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    (Text("¥")
                        .font(.title3)
                     + Text("\(Int(item.price))")
                        .font(.largeTitle.bold())
                     )
                    .foregroundColor(.cusGreen)
                }
                Spacer()
                Button {
                    showingItemDetailSheet = item
                } label: {
                    Text("追加") // Proceed to Checkout
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 80)
                        .background(Color.cusGreen)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 340, height: 260)
    }
}

#Preview {
    MenuItemViewCell(item: sampleMenuItems[0], showingItemDetailSheet: .constant(sampleMenuItems[0]))
}

#Preview {
    MenuView(navigationPath: .constant(NavigationPath()))
         .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}
