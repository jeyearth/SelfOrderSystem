//
//  MenuDetailView.swift
//  SelfOrderSystem
//
//  Created by Jey Hirano on 2025/05/26
//
//

import SwiftUI

// 2a. Menu Detail Screen (メニュー詳細画面 - presented as a sheet)
struct MenuDetailView: View {
    let item: MenuItem
    @EnvironmentObject var order: Order
    @Environment(\.dismiss) var dismiss // To close the sheet
    
    @State private var quantity: Int = 1
    // Store selected options: [OptionGroupID: SelectedOptionID] or similar
    // For this sample, we'll simplify and manage selected options directly.
    @State private var currentSelectedOptions: [MenuOption] = []
    
    // Helper to get the initial selection for an option group (e.g., "単品")
    private func initialSelection(for group: MenuOptionGroup) -> MenuOption? {
        return group.options.first(where: { $0.additionalPrice == 0 }) ?? group.options.first
    }
    
    // State for picker selections, keyed by option group ID
    @State private var pickerSelections: [UUID: MenuOption] = [:]
    
    var currentItemTotalPrice: Double {
        let basePrice = item.price
        let optionsPrice = pickerSelections.values.reduce(0) { $0 + $1.additionalPrice }
        return (basePrice + optionsPrice) * Double(quantity)
    }
    
    let leftSideWidthPercentage: CGFloat = 0.35
    
    var body: some View {
        NavigationView { // NavigationView provides a title bar for the sheet
            ScrollView {
                VStack(spacing: 15) {
                    
                    GeometryReader{ geometry in
                        
                        HStack {
                            // Left Side
                            VStack {
                                leftSideView
                            }
                            .frame(width: geometry.size.width * leftSideWidthPercentage)
                            
                            // Right Sid
                            VStack {
                                rightSideView
                            }
                            .frame(width: geometry.size.width * (1 - leftSideWidthPercentage))
                        }
                    }
                    
                    //                    Image(item.imageName) // Replace with actual image
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
                    //                        .frame(height: 250)
                    //                        .cornerRadius(10)
                    //                        .frame(maxWidth: .infinity)
                    //                        .shadow(radius: 5)
                    //
                    //                    Text(item.name)
                    //                        .font(.largeTitle.weight(.bold))
                    //
                    //                    if let description = item.description, !description.isEmpty {
                    //                        Text(description)
                    //                            .font(.body)
                    //                            .foregroundColor(.secondary)
                    //                    }
                    //
                    //                    Text("基本価格: ¥\(Int(item.price))")
                    //                        .font(.title2)
                    //
                    //                    Divider()
                    //
                    //                    // Option Groups
                    //                    if let optionGroups = item.optionGroups {
                    //                        ForEach(optionGroups) { group in
                    //                            Text(group.name)
                    //                                .font(.title3.weight(.semibold))
                    //                            // Using a Picker for single-choice options
                    //                            Picker(group.name, selection: Binding(
                    //                                get: { pickerSelections[group.id] ?? initialSelection(for: group)! },
                    //                                set: { pickerSelections[group.id] = $0 }
                    //                            )) {
                    //                                ForEach(group.options) { option in
                    //                                    Text("\(option.name) (+\(Int(option.additionalPrice))円)").tag(option)
                    //                                }
                    //                            }
                    //                            .pickerStyle(SegmentedPickerStyle()) // Or .automatic, .menu
                    //                            .padding(.bottom, 10)
                    //                        }
                    //                    }
                    //
                    //                    Divider()
                    //
                    //                    HStack {
                    //                        Text("数量:") // Quantity
                    //                            .font(.title3.weight(.semibold))
                    //                        Stepper("\(quantity)", value: $quantity, in: 1...20) // Max quantity 20
                    //                            .font(.title3)
                    //                    }
                    //
                    //                    Text("この商品の合計: ¥\(Int(currentItemTotalPrice))") // Subtotal for this item
                    //                        .font(.title2.weight(.bold))
                    //                        .padding(.vertical)
                }
                .padding()
            }
            .navigationTitle("商品詳細") // Item Details
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "xmark")
                            Text("キャンセル")
                        }
                        .font(.headline)
                    }
                    
                }
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    Button("カートに追加") { // Add to Cart
                //                        let finalSelectedOptions = Array(pickerSelections.values)
                //                        order.add(menuItem: item, quantity: quantity, selectedOptions: finalSelectedOptions)
                //                        dismiss() // Close the sheet
                //                    }
                //                    .fontWeight(.semibold)
                //                }
            }
            .onAppear {
                // Initialize picker selections
                if let optionGroups = item.optionGroups {
                    for group in optionGroups {
                        if pickerSelections[group.id] == nil {
                            pickerSelections[group.id] = initialSelection(for: group)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    MenuDetailView(item: sampleMenuItems[0])
//}

#Preview {
    MenuView(navigationPath: .constant(NavigationPath()), showingItemDetailSheet: sampleMenuItems[0])
        .environmentObject(Order()) // EnvironmentObjectが必要な場合はこれも追加（後述）
}

extension MenuDetailView {
    
    private var leftSideView: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            VStack {
                Text(item.name)
                    .font(.headline)
                Text("¥\(Int(item.price))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var rightSideView: some View {
        VStack {
            
            self.customOptionSelectView
            
            Divider()
            
            HStack {
                Text("数量:") // Quantity
                    .font(.title3.weight(.semibold))
                Stepper("\(quantity)", value: $quantity, in: 1...20) // Max quantity 20
                    .font(.title3)
            }
            
            Spacer()
            HStack {
                Text("この商品の合計: ¥\(Int(currentItemTotalPrice))") // Subtotal for this item
                //                    .font(.title2.weight(.bold))
                    .padding(.vertical)
                
                Spacer()
                Button {
                    let finalSelectedOptions = Array(pickerSelections.values)
                    order.add(menuItem: item, quantity: quantity, selectedOptions: finalSelectedOptions)
                    dismiss() // Close the sheet
                } label: {
                    Label("カートに追加", systemImage: "plus")
                    //                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 180)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func isSelected(group: MenuOptionGroup, option: MenuOption) -> Bool {
        // pickerSelections 辞書から現在のグループのIDで検索し、
        // 保存されているオプションのIDが、チェック対象のオプションのIDと一致するかどうかを返す
        return pickerSelections[group.id]?.id == option.id
    }
    
    private var customOptionSelectView: some View {
        VStack {
            if let optionGroups = item.optionGroups {
                ForEach(optionGroups) { group in
                    Text(group.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    let gridColumns: [GridItem] = [
                        .init(.adaptive(minimum: 150, maximum: 200))
                    ]
                    
                    LazyVGrid(columns: gridColumns, spacing: 10) {
                        ForEach(group.options) { option in
                            Button(action: {
                                // このグループの選択を更新
                                pickerSelections[group.id] = option
                            }) {
                                // カスタムボタンの見た目
                                VStack {
                                    Text(option.name)
                                        .font(.system(size: 14))
                                        .lineLimit(2) // 名前の表示行数を制限
                                        .fixedSize(horizontal: false, vertical: true) // 縦方向にテキストが伸びるように
                                    if option.additionalPrice > 0 {
                                        Text("+\(Int(option.additionalPrice))円")
                                            .font(.caption)
                                    } else if group.options.count == 1 && option.additionalPrice == 0 {
                                        // 価格表示なし
                                    } else {
                                        Text("(+\(Int(option.additionalPrice))円)")
                                            .font(.caption)
                                    }
                                }
                                .padding(10) // ボタンのパディングを少し調整
                                .frame(maxWidth: .infinity) // グリッドセル内で幅いっぱいに
                                .frame(minHeight: 60) // ボタンの最小高さを確保
                                .background(isSelected(group: group, option: option) ? Color.accentColor : Color(UIColor.systemGray5))
                                .foregroundColor(isSelected(group: group, option: option) ? .white : .primary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(isSelected(group: group, option: option) ? Color.clear : Color(UIColor.systemGray3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }
    
}
