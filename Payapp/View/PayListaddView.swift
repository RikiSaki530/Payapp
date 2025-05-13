//
//  PayListaddView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

struct PayListaddView: View {
    
    @ObservedObject var group : GroupData
    //新規作成用
    @State var newpayitem = PayItem(name: "", price: nil, paystatus: "➖")
    //PayList
    @EnvironmentObject var paylist : PayList
    @EnvironmentObject var Memberdata :  MemberList
    //閉じる用
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(){
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
        .onDisappear{
            paylistfireadd()
            memberfireadd()
        }
    }
    
    
    func paylistfireadd() {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Pdata = paylist.paylistitem.map{ $0.toDictionary() }
        
        docRef.updateData([
            "PayList": Pdata
        ]) { error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("PayListAddView:データを更新しました")
            }
        }
    }
    
    func memberfireadd(){
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Mdata = Memberdata.members.map { $0.toDictionary() }

        docRef.updateData([
            "MemberList": Mdata
        ]){ error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("PayListAddView:データを更新しました")
            }
        }
    }
}
