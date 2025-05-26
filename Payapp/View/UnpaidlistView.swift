//
//  UnpaidlistView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/29.
//

import SwiftUI
import FirebaseFirestore


struct UnpaidlistView: View {
    
    @Binding var item: String  // 対象の支払い項目名（例：「4月会費」）
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var Memberdata: MemberList
    
    @State private var selectValues: [UUID: Int] = [:]
    @State private var unpaidMember: [ClubMember] = []
    
    var body: some View {
        VStack {
            ForEach(unpaidMember, id: \.id) { member in
                HStack {
                    Text(member.name)
                    Spacer()
                    
                    // 対象アイテムを取得
                    if let payItem = member.paymentStatus.first(where: { $0.name == item }) {
                        Picker("", selection: Binding(
                            get: {
                                selectValues[member.id] ?? symbolToTag(payItem.paystatus)
                            },
                            set: { newValue in
                                if user.admin[group.groupCode] == true {
                                    selectValues[member.id] = newValue
                                    
                                    if let index = Memberdata.members.firstIndex(where: { $0.id == member.id }),
                                       let payIndex = Memberdata.members[index].paymentStatus.firstIndex(where: { $0.name == item }) {
                                        Memberdata.members[index].paymentStatus[payIndex].paystatus = tagToSymbol(newValue)
                                        memberfireadd()
                                    }
                                }
                            }
                        )) {
                            Text("⭕️").tag(1)
                            Text("❌").tag(2)
                            Text("➖").tag(3)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 150)
                        .disabled(!(user.admin[group.groupCode] ?? false) )
                    }
                }
            }
        }
        .onAppear {
            unpaidMemberList()
            
        }
    }
    
    func symbolToTag(_ symbol: String) -> Int {
        switch symbol {
        case "⭕️": return 1
        case "❌": return 2
        case "➖": return 3
        default: return 2
        }
    }
    
    func tagToSymbol(_ tag: Int) -> String {
        switch tag {
        case 1: return "⭕️"
        case 2: return "❌"
        case 3: return "➖"
        default: return "❌"
        }
    }
    
    func memberfireadd() {
        let db = Firestore.firestore()
        // Groupドキュメントを取得
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Mdata = Memberdata.members.map { $0.toDictionary() }
        
        docRef.updateData([
                "MemberList": Mdata
        ]) { error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("MemberAddView:データを更新しました")
            }
        }
    }
    
    // 未払いメンバーリスト作成
    func unpaidMemberList() {
        unpaidMember = Memberdata.members.filter { member in
            member.paymentStatus.contains(where: { $0.name == item && $0.paystatus == "❌" })
        }
        for member in unpaidMember {
            if let payItem = member.paymentStatus.first(where: { $0.name == item }) {
                selectValues[member.id] = symbolToTag(payItem.paystatus)
            }
        }
    }

    
}
