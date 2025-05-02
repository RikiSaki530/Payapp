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
        self.members = [
            ClubMember(name: "riki", grade: "1", schoolnumber: "245722K"),
            ClubMember(name: "kio", grade: "2", schoolnumber: "222"),
            ClubMember(name: "yu", grade: "3", schoolnumber: "333")
        ]
    }
    
    //
    func addPaymentitem(PaymentItem : PayItem) {
        let unpaidItem = PayItem(name: PaymentItem.name, price: PaymentItem.price, paystatce: "❌")
            for member in members {
                member.paymentStatus.append(unpaidItem)
            }
    }
    
    func removeallPaymentitem(rmpayitem : String) {
        for member in members {
            if let index = member.paymentStatus.firstIndex(where: { $0.name == rmpayitem }) {
                member.paymentStatus.remove(at: index)
            }
        }
    }
    
}
