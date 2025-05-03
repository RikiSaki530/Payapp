//
//  PayListaddView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct PayListaddView: View {
    
    //新規作成用
    @State var newpayitem = PayItem(name: "", price: nil, paystatus: "➖")
    //PayList
    @EnvironmentObject var paylist : PayList
    @EnvironmentObject var Memberdata :  MemberList
    //閉じる用
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(alignment :  .leading){
            Form{
                Section("支払い名義"){
                    TextField("Name" , text: $newpayitem.name)
                }
                Section("金額"){
                    TextField("price", value: $newpayitem.price, format: .number)
                        .keyboardType(.decimalPad) // 数値キーボードを表示
                }
            }
        }
        .toolbar{
            ToolbarItem{
                Button("完了"){
                    if !newpayitem.name.isEmpty &&
                        !paylist.paylistitem.contains(where: { $0.name == newpayitem.name }) {
                        paylist.paylistitem.append(newpayitem)
                        Memberdata.addPaymentitem(PaymentItem: newpayitem)
                        dismiss()
                    }
                }
            }
        }
    }
}


struct PaidList_Previews: PreviewProvider {
    static var previews: some View {
        PayListaddView()
            .environmentObject(PayList())
            .environmentObject(MemberList())
    }
}
