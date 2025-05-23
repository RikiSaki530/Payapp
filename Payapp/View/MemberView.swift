//
//  MemberView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

/**
会計以外(admin以外)は自分のものしか見れないようにする。
 */

import SwiftUI
import FirebaseFirestore

struct MemberView: View {
    
    @ObservedObject var user : User
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var data: MemberList // 親ビューから渡されたデータ
    @EnvironmentObject var listData: PayList // 親ビューから渡されたデータ
    
    var body: some View {
        List {
            // メンバーのリストを表示
            ForEach($data.members) { $member in
                NavigationLink {
                    IndividualView(individual: $member , user: user, group: group) // 個別のメンバー詳細を表示
                } label: {
                    ClubMemberRow(member: $member) // ClubMemberRowに渡す
                }
            }
            .onDelete(perform:  (user.admin[group.groupCode] ?? false) ? deleteMember : nil)
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("追加") {
                    MemberAddView(group: group)
                        .environmentObject(data) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
            }
        }
        .onAppear{
            paylistfireadd()
        }
        .onDisappear{
            memberfireadd()
            paylistfireadd()
        }
    }
    
    func deleteMember(at offsets: IndexSet) {
        for index in offsets {
            let deletedMember = data.members[index]
            data.removeallPaymentitem(rmpayitem: deletedMember.name)
        }
        data.members.remove(atOffsets: offsets)
    }
    
    func memberfireadd(){
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Mdata = data.members.map { $0.toDictionary() }

        docRef.updateData([
            "MemberList": Mdata
        ]){ error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("MemberView:データを更新しました")
            }
        }
    }
    
    func paylistfireadd() {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        let Pdata = listData.paylistitem.map{ $0.toDictionary() }
        
        docRef.updateData([
                "PayList": Pdata
        ]) { error in
                if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("MemberView:データを更新しました")
            }
        }
    }
    
    
}
