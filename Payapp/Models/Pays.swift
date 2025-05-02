//
//  Pays.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI

struct PayItem: Identifiable {
    var id = UUID()
    var name: String      // 例:「4月会費」
    var price: Int?        // 例: 1000円
    var paystatce: String  //支払い項目
}
