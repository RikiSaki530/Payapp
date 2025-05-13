//
//  MemberAddView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

struct MemberAddView : View{
    
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var Memberdata :  MemberList
    @EnvironmentObject var listData : PayList
    
    @State var newMember : ClubMember = ClubMember(name: "", grade: "" , paymentStatus:[])
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading){
            Form {
                //名前読み取り
                Section("名前") {
                    TextField("Name", text: $newMember.name)
                }
                //学年
                Section("学年"){
                    TextField("grade" , text: $newMember.grade)
                }
            }
        }
        .onAppear{
            newMember.paymentStatus = listData.paylistitem
        }
        
        .toolbar{
            ToolbarItem{
                Button("完了"){
                    if !newMember.name.isEmpty && !Memberdata.members.contains(where: { $0.name == newMember.name }) {
                        Memberdata.members.append(newMember)
                        memberfireadd()
                        dismiss()
                    }
                }
            }
        }
        .onDisappear{
            memberfireadd()
        }
        
    }
    
    func paystatusfireadd() {
        let db = Firestore.firestore()
        
        // Groupドキュメントを取得
        let docRef = db.collection("Group").document(group.groupCode)
        docRef.updateData([
                "PayList": listData
        ]) { error in
                if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("MemberAddView:データを更新しました")
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
        

        
