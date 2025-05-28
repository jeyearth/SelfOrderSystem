//
//  SampleMenuItems.swift
//  SelfOrderSystem
//  
//  Created by Jey Hirano on 2025/05/27
//  
//

import Foundation

// Sample Menu Data (Replace with your actual data)
let sampleMenuItems: [MenuItem] = [
    
    // サンドウィッチ
    MenuItem(name: "アボカドチキン", price: 800, imageName: "0101", category: .sandwich, optionGroups: [
        MenuOptionGroup(name: "基本選択", options: [ // Base Choice
            MenuOption(name: "単品", additionalPrice: 0),      // Single Item
            MenuOption(name: "セット", additionalPrice: 300)    // Set (e.g., with fries and drink)
        ]),
        MenuOptionGroup(name: "ドリンク選択 (セットの場合)", options: [ // Drink Choice (if set is chosen)
            MenuOption(name: "コカ・コーラ", additionalPrice: 0),
            MenuOption(name: "スプライト", additionalPrice: 0),
            MenuOption(name: "ジンジャーエール", additionalPrice: 0),
            MenuOption(name: "ミニッツメイド", additionalPrice: 0),
            MenuOption(name: "爽健美茶", additionalPrice: 0),
            MenuOption(name: "コーヒー", additionalPrice: 0)
        ])
    ]),
    MenuItem(name: "グリル野菜とフムス", price: 750, imageName: "0102", category: .sandwich),
    MenuItem(name: "サーモンとクリームチーズ", price: 750, imageName: "0103", category: .sandwich),
    MenuItem(name: "バジル豆腐とトマト", price: 750, imageName: "0104", category: .sandwich),
    MenuItem(name: "エッグ&ほうれん草", price: 750, imageName: "0105", category: .sandwich),
    MenuItem(name: "ツナとアボカド", price: 750, imageName: "0106", category: .sandwich),
    
    // サイドメニュー
    MenuItem(name: "フライドポテト", price: 350, imageName: "fries_placeholder", category: .side),
    
    // ドリンクメニュー
    MenuItem(name: "オレンジジュース", price: 250, imageName: "juice_placeholder", category: .drink),
    MenuItem(name: "コーヒー", price: 200, imageName: "coffee_placeholder", category: .drink)
]
