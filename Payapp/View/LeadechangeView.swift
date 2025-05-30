//
//  LeadechangeView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/29.
//

/**
 ここでリーダーを変えられるようにする。
 */


import SwiftUI
import FirebaseFirestore

struct LeadechangeView: View {
    
    @ObservedObject var user :User
    @ObservedObject var group : GroupData
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMember: (key: String, value: String)? = nil
    @State private var Alart : Bool = false
    
    var body: some View {
        
        let memberDict: [String: String] = group.AccountMemberList
        let members = memberDict.sorted(by: { $0.key < $1.key })
        
        
        List{
            ForEach(members, id: \.key) { member in
                if member.key != user.name{
                    Button(action: {
                        selectedMember = (key: member.key, value: member.value)
                        Alart = true
                    }) {
                        Text(member.key) // ← ここで表示する文字を自由に変更できる
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .alert("リーダーを変更します。よろしいですか？", isPresented: $Alart) {
                        Button("キャンセル", role: .cancel) {}
                        Button("OK", role: .destructive) {
                            if let member = selectedMember {
                                changeLeader(username: member.key , userId: member.value)
                            }
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func changeLeader(username : String , userId : String){
        let db = Firestore.firestore()
        
        let newLeader : [String : String] = [
            username : userId
        ]
        
        print(newLeader)
        
        db.collection("Group").document(group.groupCode).updateData([
            "Leader": newLeader
        ]) { error in
            if let error = error {
                print("エラー: \(error)")
            } else {
                print("Leaderフィールドを更新しました")
            }
        }
        
        group.Leader = newLeader
    }
}
