//
//  Pays.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI

struct PayItem: Identifiable, Codable , Hashable {
    var id = UUID()
    var name: String      // 例:「4月会費」
    var price: Int?        // 例: 1000円
    var paystatus: String  //支払い項目
    
    init(name:String , price : Int? , paystatus :String){
        self.name = name
        self.price = price
        self.paystatus = paystatus
    }
    
    // Firestoreに保存するための辞書変換
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "paystatus": paystatus
        ]
        if let price = price {
            dict["price"] = price
        }
        return dict
    }
    
}
