//
//  MastPay View.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI

struct MastPayView: View{
    
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
                .onDelete { indexSet in
                    for index in indexSet {
                        let deletedItem = paylist.paylistitem[index]
                        Memberdata.removeallPaymentitem(rmpayitem: deletedItem.name)
                    }
                    
                    paylist.paylistitem.remove(atOffsets: indexSet)
                }
            }
        }
    }
}


struct ContentSecondView_Previews: PreviewProvider {
    static var previews: some View {
        // ⭐️ ダミーデータの作成
        let previewPaylist = PayList()
        previewPaylist.paylistitem = [
            PayItem(name: "4月会費", price: 1000, paystatce: "❌"),
            PayItem(name: "5月会費", price: 1200, paystatce: "⭕️"),
            PayItem(name: "イベント費", price: 500, paystatce: "➖")
        ]

        return MastPayView()
            .environmentObject(previewPaylist)
    }
}
