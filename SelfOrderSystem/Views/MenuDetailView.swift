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
    @State private var currentSelectedOptions: [MenuOption] = []
    
    private func initialSelection(for group: MenuOptionGroup) -> MenuOption? {
        return group.options.first(where: { $0.additionalPrice == 0 }) ?? group.options.first
    }
    
    @State private var pickerSelections: [UUID: MenuOption] = [:]
    
    var currentItemTotalPrice: Double {
        let basePrice = item.price
        let optionsPrice = pickerSelections.values.reduce(0) { $0 + $1.additionalPrice }
        return (basePrice + optionsPrice) * Double(quantity)
    }
    
    let leftSideWidthPercentage: CGFloat = 0.30
    
    private var isSingleItemSelected: Bool {
        // 1. 「セット選択」グループを探す
        guard let setGroup = item.optionGroups?.first(where: { $0.name ==  sandwichOptionGroups[0].name}) else {
            return false // 「セット選択」グループが見つからなければ判定不可
        }
        
        // 2. 「セット選択」グループで現在選択されているオプションを取得
        guard let selectedSetOption = pickerSelections[setGroup.id] else {
            return false
        }
        
        // 3. 選択されているオプションが「単品」かどうかをチェック
        return selectedSetOption.name == sandwichOptionGroups[0].options[0].name
    }
    
    var body: some View {
        NavigationView { // NavigationView provides a title bar for the sheet
            VStack {
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
                }
                .padding(20)
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
                        .font(.title3)
                        .fontWeight(.bold)
                    }
                    
                }
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
                .frame(height: 120)
                .frame(width: 140)
                .shadow(radius: 4)
            VStack {
                Text(item.name)
                    .font(.headline)
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack {
                
                // 1. 基本料金
                HStack {
                    Text("基本料金")
                    Spacer()
                    Text("¥\(Int(item.price))")
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                
                // 2. オプション料金
                let calculatedOptionsPrice = pickerSelections.values.reduce(0) { $0 + $1.additionalPrice }
                HStack {
                    Text("オプション料金")
                    Spacer()
                    Text("¥\(Int(calculatedOptionsPrice))")
                        .fontWeight(.medium)
                        .contentTransition(.numericText(value: calculatedOptionsPrice))
                        .animation(.default, value: calculatedOptionsPrice)
                }
                .font(.subheadline)
                
                Divider()
                
                // 3. 小計（単価：基本料金 + オプション料金）
                let subtotalPerItem = item.price + calculatedOptionsPrice
                HStack {
                    Text("小計（単価）")
                        .fontWeight(.bold)
                    Spacer()
                    Text("¥\(Int(subtotalPerItem))")
                        .fontWeight(.bold)
                        .contentTransition(.numericText(value: subtotalPerItem))
                        .animation(.default, value: subtotalPerItem)
                }
                .font(.subheadline) // 基本料金などと同じサイズ感で、太字で区別
                
                Divider()
                
                // 4. 数量
                HStack {
                    Text("数量")
                    Spacer()
                    Text("\(quantity) 点")
                        .fontWeight(.medium)
                        .contentTransition(.numericText(value: Double(quantity))) // quantityもアニメーション対象に
                        .animation(.default, value: quantity)
                }
                .font(.subheadline)
                
                Divider()
                    .padding(.vertical, 4)
                
                // 5. 合計（単価 × 数量）
                HStack(alignment: .bottom) {
                    Text("合計")
                        .font(.subheadline.weight(.bold))
                        .padding(.bottom, 4)
                    Spacer()
                    (Text("¥")
                        .font(.title3)
                     + Text("\(Int(currentItemTotalPrice))")
                        .font(.system(size: 30, weight: .heavy))
                    )
                    .foregroundColor(.cusGreen)
                    
                }
                .contentTransition(.numericText(value: currentItemTotalPrice))
                .animation(.default, value: currentItemTotalPrice)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var rightSideView: some View {
        VStack {
            
            self.customOptionSelectView
            
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Button {
                        withAnimation {
                            if quantity == 1 { return }
                            quantity -= 1
                        }
                    } label: {
                        Image(systemName: "minus.square.fill")
                            .foregroundColor(Color(UIColor.systemGray4))
                    }
                    Text("\(quantity)")
                        .fontWeight(.bold)
                        .contentTransition(.numericText(value: Double(quantity)))
                        .padding(.horizontal, 8)
                    Button {
                        withAnimation {
                            if quantity == 20 { return }
                            quantity += 1
                        }
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .foregroundColor(Color(UIColor.systemGray4))
                        
                    }
                }
                .font(.largeTitle)
                Spacer()
                Button {
                    withAnimation {
                        let finalSelectedOptions = Array(pickerSelections.values)
                        order.add(menuItem: item, quantity: quantity, selectedOptions: finalSelectedOptions)
                        dismiss() // Close the sheet
                    }
                } label: {
                    Label("カートに追加", systemImage: "plus")
                        .font(.title3.weight(.semibold))
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
        return pickerSelections[group.id]?.id == option.id
    }
    
    private var customOptionSelectView: some View {
        VStack {
            if let optionGroups = item.optionGroups {
                ForEach(optionGroups) { group in
                    
                    let shouldDisableThisGroup = (group.name == sandwichOptionGroups[1].name && isSingleItemSelected)
                    
                    if !shouldDisableThisGroup {
                        
                        Text(group.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        let gridColumns: [GridItem] = [
                            .init(.adaptive(minimum: 140, maximum: 260))
                        ]
                        
                        LazyVGrid(columns: gridColumns, spacing: 10) {
                            ForEach(group.options) { option in
                                Button(action: {
                                    withAnimation {
                                        pickerSelections[group.id] = option
                                    }
                                }) {
                                    // カスタムボタンの見た目
                                    VStack {
                                        HStack {
                                            if let imageName = option.imageName {
                                                Image(imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24, height: 24)
                                            }
                                            VStack {
                                                Text(option.name)
                                                    .font(.subheadline.bold())
                                                    .lineLimit(2) // 名前の表示行数を制限
                                                    .fixedSize(horizontal: false, vertical: true) // 縦方向にテキストが伸びるように
                                                    .frame(maxWidth:. infinity, alignment: .leading)
                                                Spacer()
                                                if option.additionalPrice > 0 {
                                                    Text("+\(Int(option.additionalPrice))円")
                                                        .font(.caption)
                                                        .frame(maxWidth:. infinity, alignment: .leading)
                                                } else if group.options.count == 1 && option.additionalPrice == 0 {
                                                    // 価格表示なし
                                                } else {
                                                    Text("(+\(Int(option.additionalPrice))円)")
                                                        .font(.caption)
                                                        .frame(maxWidth:. infinity, alignment: .leading)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: 72)
                                    .background(isSelected(group: group, option: option) ? Color.clear : Color.clear)
                                    .foregroundColor(isSelected(group: group, option: option) ? .primary : .primary)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected(group: group, option: option) ? Color.accentColor : Color(UIColor.systemGray3), lineWidth: 2)
                                            .strokeBorder(isSelected(group: group, option: option) ? Color.accentColor : .clear, lineWidth: 2.5)
                                    )
                                }
                                .disabled(shouldDisableThisGroup)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
        }
    }
    
}
