//
//  MemberList.swift
//  Payapp
//
//  MemberList.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/27.
//

import SwiftUI
import FirebaseFirestore
import Firebase

//メンバーのリストを管理

class MemberList: ObservableObject, Codable {
    
    @Published var members: [ClubMember] = []
    
    
    enum CodingKeys: String, CodingKey {
        case members
    }
    
    
    init() {
        self.members = []
    }
    
    
    
    // Decodableに準拠するためのイニシャライザ
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedMembers = try container.decode([ClubMember].self, forKey: .members)
        self.members = decodedMembers
    }
    
    // Encodableに準拠するためのエンコードメソッド
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(members, forKey: .members) // members をエンコード
    }

    
    //これは残しておく
    func removeallPaymentitem(rmpayitem : String) {
        for i in members.indices {
            if let index = members[i].paymentStatus.firstIndex(where: { $0.name == rmpayitem }) {
                members[i].paymentStatus.remove(at: index)
            }
        }
    }
    
    func addPaymentitem(PaymentItem : PayItem) {
        let unpaidItem = PayItem(name: PaymentItem.name, price: PaymentItem.price, paystatus: "❌")
        for i in members.indices {
            members[i].paymentStatus.append(unpaidItem)
        }
    }
    
}
