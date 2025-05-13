//
//  PayList.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase

//リスト作成

class PayList: ObservableObject , Codable{
    @Published var paylistitem: [PayItem] = []
    
    // Decodable に準拠するためのイニシャライザ
    enum CodingKeys: String, CodingKey {
        case paylistitem
    }
    
    // ✅ 通常の初期化用イニシャライザ（必要！）
    init() {
        self.paylistitem = []
    }
    
    
    // 初期化メソッド (デコード用)
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodePayitem = try container.decode([PayItem].self, forKey: .paylistitem)
        self.paylistitem = decodePayitem
        
    }
    
    // Encodableに準拠するためのエンコードメソッド
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(paylistitem, forKey: .paylistitem) // paulistitem をエンコード
    }
    
    
}

