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
//                    Picker("カテゴリー", selection: $selectedCategory) {
//                        ForEach(MenuCategory.allCases) { category in
//                            Text(category.rawValue).tag(category)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(.horizontal)
//                    .padding(.bottom, 10)
                    
                    self.customMenuCategorySegmentedControl
                        .padding()

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
                                HStack {
                                    Image(orderItem.menuItem.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
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
                                        Image(systemName: "trash.fill") // アイコン変更、fillで塗りつぶし
                                            .font(.title2) // アイコンサイズ調整
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
//                            .onDelete(perform: order.removeItem) // Allow swipe to delete
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

extension MenuView {
    
    private var customMenuCategorySegmentedControl: some View {
        VStack {
            HStack(spacing: 16) {
                ForEach(MenuCategory.allCases) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        VStack {
                            Text(category.rawValue)
                                .foregroundColor(.primary)
                        }
                        .frame(width: 100)
                        .padding(16)
                        .overlay {
                            RoundedRectangle(cornerRadius: 40)
                                .strokeBorder(selectedCategory == category ? Color.accentColor : Color.gray, lineWidth: 2.5)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
    }
    
//    private var customOptionSelectView: some View {
//        VStack {
//            if let optionGroups = item.optionGroups {
//                ForEach(optionGroups) { group in
//                    Text(group.name)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .font(.title3)
//                        .fontWeight(.bold)
//
//                    let gridColumns: [GridItem] = [
//                        .init(.adaptive(minimum: 140, maximum: 260))
//                    ]
//
//                    LazyVGrid(columns: gridColumns, spacing: 10) {
//                        ForEach(group.options) { option in
//                            Button(action: {
//                                // このグループの選択を更新
//                                withAnimation {
//                                    pickerSelections[group.id] = option
//                                }
//                            }) {
//                                // カスタムボタンの見た目
//                                VStack {
//                                    Text(option.name)
//                                        .font(.system(size: 14))
//                                        .lineLimit(2) // 名前の表示行数を制限
//                                        .fixedSize(horizontal: false, vertical: true) // 縦方向にテキストが伸びるように
//                                    if option.additionalPrice > 0 {
//                                        Text("+\(Int(option.additionalPrice))円")
//                                            .font(.caption)
//                                    } else if group.options.count == 1 && option.additionalPrice == 0 {
//                                        // 価格表示なし
//                                    } else {
//                                        Text("(+\(Int(option.additionalPrice))円)")
//                                            .font(.caption)
//                                    }
//                                }
//                                .padding(10) // ボタンのパディングを少し調整
//                                .frame(maxWidth: .infinity) // グリッドセル内で幅いっぱいに
//                                .frame(minHeight: 60) // ボタンの最小高さを確保
//                                .background(isSelected(group: group, option: option) ? Color.clear : Color.clear)
//                                .foregroundColor(isSelected(group: group, option: option) ? .primary : .primary)
//                                .cornerRadius(8)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(isSelected(group: group, option: option) ? Color.accentColor : Color(UIColor.systemGray3), lineWidth: 2)
//                                        .strokeBorder(isSelected(group: group, option: option) ? Color.accentColor : .clear, lineWidth: 2.5)
//                                )
//                            }
//                        }
//                    }
//                    .padding(.bottom, 24)
//                }
//            }
//        }
//    }
    
}
