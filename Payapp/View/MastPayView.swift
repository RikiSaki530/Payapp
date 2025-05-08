//
//  MastPay View.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct MastPayView: View{
    
    @ObservedObject var user : User
    @Binding var group : GroupData
    
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
    }
}


/**
struct ContentSecondView_Previews: PreviewProvider {
    static var previews: some View {
        // ⭐️ ダミーデータの作成
        let previewPaylist = PayList()
        
        @State var user1 = User(name: "", Mailaddress: "", Password: "", admin: true, groupList: [] , UserID: 0)
        
        @State var user2 = User(name: "", Mailaddress: "", Password: "", admin: false, groupList: [] , UserID: 0)
        
        previewPaylist.paylistitem = [
            PayItem(name: "4月会費", price: 1000, paystatus: "❌"),
            PayItem(name: "5月会費", price: 1200, paystatus: "⭕️"),
            PayItem(name: "イベント費", price: 500, paystatus: "➖")
        ]
        
        return
            MastPayView(user:$user2)
                .environmentObject(previewPaylist)
                .environmentObject(MemberList())
        
        }
}
*/
