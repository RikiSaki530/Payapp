//
//  PayitemView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/26.
//

import SwiftUI
import FirebaseFirestore

struct PayitemView: View {
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @Binding var payitem: PayItem
    @EnvironmentObject var listData: PayList
    @EnvironmentObject var Memberdata: MemberList
    
    @State private var selectValues: [UUID: Int] = [:]
    @State private var targetMembers: [ClubMember] = []
    
    var body: some View {
        VStack {
            HStack {
                Text(payitem.name)
                        .font(.title) // 文字を太くする
                        .padding(.leading, 48)  // 左端に余白を少し追加
                    
                    Spacer()
                    
                    if let price = payitem.price, price > 0 {
                        Text("\(price)円")
                            .font(.title)
                            .padding(.trailing, 48)  // 右端に余白を少し追加
                    }
            }
            List {
                ForEach(targetMembers, id: \.id) { member in
                    HStack {
                        Text(member.name)
                        Spacer()
                        Picker("", selection: Binding(
                            get: {
                                selectValues[member.id] ?? symbolToTag(payitem.paystatus)
                            },
                            set: { newValue in
                                if user.admin[group.groupCode] == true {
                                    selectValues[member.id] = newValue
                                    
                                    // メンバー配列のインデックスを探す
                                    if let memberIndex = Memberdata.members.firstIndex(where: { $0.id == member.id }),
                                       let payIndex = Memberdata.members[memberIndex].paymentStatus.firstIndex(where: { $0.name == payitem.name }) {
                                        
                                        // 状態を更新
                                        Memberdata.members[memberIndex].paymentStatus[payIndex].paystatus = tagToSymbol(newValue)
                                        
                                        // Firestoreへ反映
                                        memberfireadd()
                                    }
                                } else {
                                    // 管理者でない場合は変更を無視するか、
                                    // 何か警告表示する処理を入れても良い
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
            createPayItemList()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("編集") {
                    ChangePayinfoView(user: user , group: group, payitem: $payitem)
                        .environmentObject(Memberdata) // 必要なら渡す
                        .environmentObject(listData)
                }
            }
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
    
    func createPayItemList() {
        // 対象の項目を持つメンバーのみ抽出
        targetMembers = Memberdata.members.filter { member in
            member.paymentStatus.contains(where: { $0.name == payitem.name })
        }
        
        // 各メンバーのステータスを初期化
        for member in targetMembers {
            if let status = member.paymentStatus.first(where: { $0.name == payitem.name })?.paystatus {
                selectValues[member.id] = symbolToTag(status)
            }
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
    
}
