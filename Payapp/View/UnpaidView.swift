//
//  UnpaidView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/28.
//

import SwiftUI

struct UnpaidView: View {
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var data: MemberList
    @EnvironmentObject var listData: PayList
    @State var unpaidlist: [String] = []
    
    var body: some View {
        
        NavigationStack {
            List {
                // ForEachでunpaidListのアイテムを表示
                ForEach($unpaidlist, id: \.self) { $item in
                    Section(item) {
                        // unpaidMemberを使って未払いのメンバーを表示
                        UnpaidlistView(item: $item, user :user , group: group)
                    }
                }
            }
            .onAppear {
                unpaidList()  // `unpaidList`を初期化する
            }
        }
    }
    
    
    func unpaidList() {
        unpaidlist = []  // 念のため初期化

        for item in listData.paylistitem {
            for member in data.members {
                if let status = member.paymentStatus.first(where: { $0.name == item.name })?.paystatus,
                   status == "❌" {
                    unpaidlist.append(item.name)
                    break
                }
            }
        }
    }

}

