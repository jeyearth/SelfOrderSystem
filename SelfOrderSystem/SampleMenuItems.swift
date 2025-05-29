//
//  SampleMenuItems.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/27
//  
//

import Foundation

let drinkOptionGroups: [MenuOptionGroup] = [
    MenuOptionGroup(name: "サイズ", options: [
        MenuOption(name: "S", additionalPrice: 0),
        MenuOption(name: "M", additionalPrice: 80),
        MenuOption(name: "L", additionalPrice: 120),
    ])
]

let drinkMenuItems: [MenuItem] = [
    MenuItem(name: "コーラ", price: 200, imageName: "0301coca-cola", category: .drink, optionGroups: drinkOptionGroups),
    MenuItem(name: "スプライト", price: 200, imageName: "0302sprite", category: .drink, optionGroups: drinkOptionGroups),
    MenuItem(name: "ファンタグレープ", price: 200, imageName: "0303fanta-grape", category: .drink, optionGroups: drinkOptionGroups),
    MenuItem(name: "オレンジジュース", price: 200, imageName: "0304orange-juice", category: .drink, optionGroups: drinkOptionGroups),
    MenuItem(name: "ウーロン茶", price: 200, imageName: "0305tea", category: .drink, optionGroups: drinkOptionGroups),
    MenuItem(name: "アイスコーヒー", price: 200, imageName: "0306ice-coffee", category: .drink, optionGroups: drinkOptionGroups),
]

func setDrinkOptionItems(_ drinkMenuItems: [MenuItem]) -> [MenuOption] {
    var drinkOptionItems: [MenuOption] = []
    for drinkMenuItem in drinkMenuItems {
        drinkOptionItems.append(contentsOf: [
            MenuOption(name: drinkMenuItem.name, additionalPrice: 0, imageName: drinkMenuItem.imageName)
        ])
    }
    return drinkOptionItems
}

let drinkOptionItems: [MenuOption] = setDrinkOptionItems(drinkMenuItems)

let sandwichOptionGroups: [MenuOptionGroup] = [
    MenuOptionGroup(name: "基本選択", options: [ // Base Choice
        MenuOption(name: "単品", additionalPrice: 0),      // Single Item
        MenuOption(name: "セット(ドリンクM, ポテトM)", additionalPrice: 300)    // Set (e.g., with fries and drink)
    ]),
    MenuOptionGroup(name: "ドリンク選択 (セットの場合)", options: drinkOptionItems)
]

// Sample Menu Data (Replace with your actual data)
let sampleMenuItems: [MenuItem] = [
    
    // サンドウィッチ
    MenuItem(name: "アボカドチキン", price: 800, imageName: "0101", category: .sandwich, optionGroups: sandwichOptionGroups),
    MenuItem(name: "グリル野菜とフムス", price: 750, imageName: "0102", category: .sandwich, optionGroups: sandwichOptionGroups),
    MenuItem(name: "サーモンとクリームチーズ", price: 750, imageName: "0103", category: .sandwich, optionGroups: sandwichOptionGroups),
    MenuItem(name: "バジル豆腐とトマト", price: 750, imageName: "0104", category: .sandwich, optionGroups: sandwichOptionGroups),
    MenuItem(name: "エッグ&ほうれん草", price: 750, imageName: "0105", category: .sandwich, optionGroups: sandwichOptionGroups),
    MenuItem(name: "ツナとアボカド", price: 750, imageName: "0106", category: .sandwich, optionGroups: sandwichOptionGroups),
    
    // サイドメニュー
    MenuItem(name: "フライドポテト", price: 200, imageName: "0201", category: .side, optionGroups: [
        MenuOptionGroup(name: "サイズ", options: [
            MenuOption(name: "S", additionalPrice: 0),
            MenuOption(name: "M", additionalPrice: 130),
            MenuOption(name: "L", additionalPrice: 180),
            MenuOption(name: "LL", additionalPrice: 220),
        ]),
    ]),
    
] + drinkMenuItems
