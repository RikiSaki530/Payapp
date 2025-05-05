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

//メンバーのリストを管理

class MemberList : ObservableObject{
    
    @Published var members: [ClubMember] = []
    
    init() {
        // 全員が同じ PayList を参照
        self.members = []
    }
    
    //
    func addPaymentitem(PaymentItem : PayItem) {
        let unpaidItem = PayItem(name: PaymentItem.name, price: PaymentItem.price, paystatus: "❌")
            for i in members.indices {
                    members[i].paymentStatus.append(unpaidItem)
            }
    }
    
    func removeallPaymentitem(rmpayitem : String) {
        for i in members.indices {
            if let index = members[i].paymentStatus.firstIndex(where: { $0.name == rmpayitem }) {
                members[i].paymentStatus.remove(at: index)
            }
        }
    }
    
    func decodeMemberlist(memberlist : [ClubMember]){
        self.members = memberlist
    }
}
