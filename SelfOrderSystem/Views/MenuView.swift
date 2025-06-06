//
//  MenuView.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/26
//  
//

import SwiftUI

// 2. Menu Screen (メニュー画面)
struct MenuView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var order: Order // Access the shared order object
    @State private var selectedCategory: MenuCategory = .sandwich
    @State var showingItemDetailSheet: MenuItem? = nil // Controls the presentation of the detail sheet
    
    // Filters menu items based on the selected category
    var currentCategoryItems: [MenuItem] {
        sampleMenuItems.filter { $0.category == selectedCategory }
    }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 320, maximum: 360)), count: 2) // Adaptive columns
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                // Main content area for menu items
                VStack(alignment: .leading) {
                    Text("メニューを選択") // Select Menu
                        .font(.largeTitle.weight(.bold))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                    // Category selection
                    
                    self.customMenuCategorySegmentedControl
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    
                    // Grid of menu items
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(currentCategoryItems) { item in
                                MenuItemViewCell(item: item, showingItemDetailSheet: $showingItemDetailSheet)
                            }
                        }
                        .padding()
                    }
                }
                .frame(width: geometry.size.width * 0.65) // Menu items take up 65% of width
                
                // Order summary sidebar
                VStack(spacing: 0) {
                    Text("ご注文内容") // Your Order
                        .font(.title2.weight(.semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                        .padding()
                    
                    if order.items.isEmpty {
                        Spacer()
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("商品はまだ追加されていません。") // No items added yet.
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(order.items) { orderItem in
                                HStack {
                                    Image(orderItem.menuItem.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                    VStack {
                                        Text("\(orderItem.menuItem.name)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        HStack {
                                            VStack(alignment: .leading){
                                                if orderItem.selectedOptions.isEmpty {
                                                    Text("オプションなし")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                } else {
                                                    ForEach(orderItem.selectedOptions){ option in
                                                        Text("+ \(option.name)")
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                                }
                                                HStack {
                                                    Text("x \(orderItem.quantity)")
                                                        .padding(.horizontal, 8)
                                                    Spacer()
                                                    (Text("¥")
                                                        .font(.headline.bold())
                                                     + Text("\(Int(orderItem.totalPrice))")
                                                        .font(.title2.bold())
                                                    )
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.trailing, 10)
                                        }
                                    }
                                    .frame(maxHeight: 90)
                                    Button(action: {
                                        print("Delete item: \(orderItem.menuItem.name)")
                                        withAnimation {
                                            order.removeItem(id: orderItem.id)
                                        }
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 10)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    VStack {
                        
                        (Text("合計: ¥ ")
                            .font(.system(size: 30, weight: .semibold))
                         + Text("\(Int(order.totalAmount))")
                            .font(.system(size: 80, weight: .bold))
                        )
                        .contentTransition(.numericText(value: order.totalAmount))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                        
                        Button(action: {
                            if !order.items.isEmpty {
                                navigationPath.append(NavigationRoute.paymentMethodSelection) // Proceed to payment
                            }
                        }) {
                            Text("お会計へ進む") // Proceed to Checkout
                                .font(.title.weight(.semibold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(order.items.isEmpty ? Color.gray : Color.cusGreen)
                                .cornerRadius(10)
                        }
                        .disabled(order.items.isEmpty)
                        .padding([.horizontal, .bottom])
                    }
                }
                .frame(width: geometry.size.width * 0.35) // Order summary takes 35%
                .background(Color(UIColor.systemGray6))
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationPath.removeLast(navigationPath.count) // Go back to Top screen
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("トップに戻る")
                    }
                }
                .foregroundColor(.cusGreen)
                .font(.title.bold())
            }
        }
        .sheet(item: $showingItemDetailSheet) { item in
            // Present MenuDetailView as a sheet
            MenuDetailView(item: item)
        }
    }
}

#Preview {
    MenuView(navigationPath: .constant(NavigationPath()))
        .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}

extension MenuView {
    
    private var customMenuCategorySegmentedControl: some View {
        VStack {
            HStack(spacing: 16) {
                ForEach(MenuCategory.allCases) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack {
                            Image(category.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 32)
                                .padding(.leading, 12)
                            Text(category.rawValue)
                                .font(.system(size: 20, weight: selectedCategory == category ? .bold : .medium))
                                .padding(.leading, 4)
                                .padding(.vertical, 10)
                                .foregroundColor(selectedCategory == category ? .white : Color(UIColor.label))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(
                            ZStack {
                                if selectedCategory == category {
                                    Capsule()
                                        .fill(Color.cusGreen)
                                        .frame(height: 60)
                                } else {
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .frame(height: 60)
                                }
                            }
                        )
                        .frame(width: 220, height: 100)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
    }
    
}
