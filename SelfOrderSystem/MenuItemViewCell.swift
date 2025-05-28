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
//            Image(item.imageName) // Replace with actual image loading
//                .resizable()
////                .aspectRatio(contentMode: .fill)
//                .aspectRatio(contentMode: .fit)
//                .frame(height: 120)
//                .frame(maxWidth: .infinity)
//                .clipped()
//                .cornerRadius(8)
//                .shadow(radius: 3)
//                .overlay(
//                    VStack { // Price overlay
//                        Spacer()
//                        Text("¥\(Int(item.price))")
//                            .font(.headline)
//                            .padding(5)
//                            .background(Color.black.opacity(0.6))
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                    }
//                    .padding(5), alignment: .bottomTrailing
//                )
//            
//            Spacer()
//
//            Text(item.name)
//                .font(.headline)
//                .lineLimit(2)
//                .padding(.top, 5)
//
//            Text(item.category.rawValue)
//                .font(.caption)
//                .foregroundColor(.gray)
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .frame(width: 220)
                .padding(.bottom)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text("¥\(Int(item.price))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                Spacer()
                Button {
                    showingItemDetailSheet = item
                } label: {
                    Text("追加") // Proceed to Checkout
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 80)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Use system background for light/dark mode
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
