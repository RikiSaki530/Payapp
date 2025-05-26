//
//  MastPay View.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

struct MastPayView: View{
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    //paylist
    @EnvironmentObject var paylist : PayList
    @EnvironmentObject var Memberdata : MemberList
    
    //リストごとに払ってない人表示
    //もしゼロなら表示しない。←これは後で実装する
    
    
    var body : some View{
        VStack{
            List{
                ForEach(paylist.paylistitem){ item in
                    HStack{
                        Text(item.name)
                        Spacer()
                        if let price = item.price, price > 0 {
                            Text("\(price)円")
                        }
                    }
                }
                .onDelete(perform: (user.admin[group.groupCode] ?? false) ? deleteItems : nil)
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let deletedItem = paylist.paylistitem[index]
            Memberdata.removeallPaymentitem(rmpayitem: deletedItem.name)
        }
        paylist.paylistitem.remove(atOffsets: offsets)
        
        // Firestoreへ更新
        memberfireadd()    // Memberdataの変更を反映
        paylistfireadd(){}
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
                print("contentView:データを更新しました")
            }
        }
    }
    
    func paylistfireadd(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Pdata = paylist.paylistitem.map{ $0.toDictionary() }
        
        docRef.updateData([
                "PayList": Pdata
        ]) { error in
                if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("contentView:データを更新しました")
            }
        completion()
        }
        
    }
}


