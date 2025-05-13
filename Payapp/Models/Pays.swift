//
//  Pays.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI

struct PayItem: Identifiable, Hashable, Codable {
    var id = UUID()          // Firestore保存時に除外しても良い
    var name: String         // 例:「4月会費」
    var price: Int?          // 例: 1000円
    var paystatus: String    // 支払い項目
    
    // イニシャライザ
    init(name: String, price: Int?, paystatus: String) {
        self.name = name
        self.price = price
        self.paystatus = paystatus
    }

    // Firestoreからのデータを基にPayItemを作成
    init(from firestoreData: [String: Any]) {
        self.name = firestoreData["name"] as? String ?? ""
        self.price = firestoreData["price"] as? Int
        self.paystatus = firestoreData["paystatus"] as? String ?? ""
    }

    // `id` を除外してデコード
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case paystatus
    }

    // Firestoreのデータを辞書形式に変換
    func toDictionary() -> [String: Any] {
        return [
            "name": self.name,
            "price": self.price as Any,
            "paystatus": self.paystatus
        ]
    }
}
