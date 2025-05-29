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
                        .padding([.top, .leading])

                    // Category selection
                    Picker("カテゴリー", selection: $selectedCategory) {
                        ForEach(MenuCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                    // Grid of menu items
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(currentCategoryItems) { item in
//                                Button(action: {
//                                    showingItemDetailSheet = item // Show detail sheet for the selected item
//                                }) {
//                                    MenuItemViewCell(item: item, showingItemDetailSheet: $showingItemDetailSheet)
//                                }
//                                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle for custom button appearance
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
//                        .background(Color.gray.opacity(0.2))
                    
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
                                VStack {
                                    Text("\(orderItem.menuItem.name)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    HStack {
                                        VStack(alignment: .leading){
                                            ForEach(orderItem.selectedOptions){ option in
                                                Text("+ \(option.name)")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .frame(width: 150)
                                        .padding(.trailing, 20)
                                        Text("x \(orderItem.quantity)")
                                            .padding(.horizontal, 8)
                                        Spacer()
                                        (Text("¥")
                                            .font(.title3.bold())
                                        + Text("\(Int(orderItem.totalPrice))")
                                            .font(.title.bold())
                                         )
                                    }
                                }
                                .padding(.all, 10)
                                .frame(maxWidth: .infinity, minHeight: 90)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: order.removeItem) // Allow swipe to delete
                        }
                        .listStyle(.plain)
//                        .listStyle(PlainListStyle()) // Use PlainListStyle for cleaner look
                    }

                    Divider()
                        .padding()
                    VStack {
                        
                        (Text("合計: ¥ ")
                            .font(.system(size: 30, weight: .semibold))
                         + Text("\(Int(order.totalAmount))")
                            .font(.system(size: 80, weight: .bold))
                        )
                        .contentTransition(.numericText(value: order.totalAmount))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()

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
                                .background(order.items.isEmpty ? Color.gray : Color.green)
                                .cornerRadius(10)
                        }
                        .disabled(order.items.isEmpty)
                        .padding([.horizontal, .bottom])
                    }
//                    .background(Color.gray.opacity(0.1))
                }
                .frame(width: geometry.size.width * 0.35) // Order summary takes 35%
                .background(Color(UIColor.systemGray6))
                
            }
        }
        .navigationTitle("メニュー") // Menu
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationPath.removeLast(navigationPath.count) // Go back to Top screen
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("トップに戻る") // Back to Top
                    }
                }
            }
            if !order.items.isEmpty {
                 ToolbarItem(placement: .navigationBarTrailing) {
                     EditButton() // To enable swipe-to-delete in the order list
                 }
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
