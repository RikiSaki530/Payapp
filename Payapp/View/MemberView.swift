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
    
    @EnvironmentObject var Memberdata: MemberList // 親ビューから渡されたデータ
    @EnvironmentObject var listData: PayList // 親ビューから渡されたデータ
    
    @State private var selectedIndex: Int? = nil  // 選択された行のIndexを保持
    
    var body: some View {
        List {
            // メンバーのリストを表示
            ForEach($Memberdata.members) { $member in
                NavigationLink {
                    IndividualView(individual: $member , user: user, group: group) // 個別のメンバー詳細を表示
                        .environmentObject(Memberdata)
                } label: {
                    ClubMemberRow(member: $member) // ClubMemberRowに渡す
                }
            }
            //スライドして消せる
            .onDelete(perform:  (user.admin[group.groupCode] ?? false) ? deleteMember : nil)
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("追加") {
                    MemberAddView(group: group)
                        .environmentObject(Memberdata) // MemberListデータを渡す
                        .environmentObject(listData) // PayListデータを渡す
                }
            }
        }
    }
    
    func deleteMember(at offsets: IndexSet) {
        for index in offsets {
            let deletedMember = Memberdata.members[index]
            Memberdata.removeallPaymentitem(rmpayitem: deletedMember.name)
        }
        Memberdata.members.remove(atOffsets: offsets)
        memberfireadd()
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
                print("MemberView:データを更新しました")
            }
        }
    }
    
}
