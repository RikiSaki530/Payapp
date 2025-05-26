//
//  ChangeUserInfoView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/26.
//

import SwiftUI
import FirebaseFirestore

struct ChangeUserInfoView: View {
    @ObservedObject var group : GroupData
    
    @EnvironmentObject var Memberdata :  MemberList
    
    @Binding var individual : ClubMember
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    @State private var isDuplicate = false
    
    var body: some View {
        VStack(alignment: .leading){
            Form {
                //名前読み取り
                Section("名前") {
                    TextField("Name", text: $individual.name)
                }
                //学年
                Section("学年"){
                    TextField("grade" , text: $individual.grade)
                }
            }
        }
        
        
        .toolbar{
            ToolbarItem{
                Button("完了"){
                    
                    memberchange()
                    
                    if individual.name.isEmpty {
                        showAlert = true
                        isDuplicate = false
                    } else if Memberdata.members.contains(where: { $0.name == individual.name && $0.id != individual.id }) {
                        isDuplicate = true
                        showAlert = true
                    } else {
                        memberfireadd()
                        dismiss()
                    }
                }
                .alert(isPresented: $showAlert) {
                    if isDuplicate {
                        return Alert(
                            title: Text("確認"),
                            message: Text("すでに登録されている名前です。変更しますか？"),
                            primaryButton: .default(Text("追加する")) {
                                memberfireadd()
                                dismiss()
                            },
                            secondaryButton: .cancel(Text("キャンセル"))
                        )
                    } else {
                        return Alert(
                            title: Text("エラー"),
                            message: Text("名前が空欄です。入力してください。"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            
        }
    }
    
    func memberchange() {
        if let index = Memberdata.members.firstIndex(where: { $0.id == individual.id }) {
            Memberdata.members[index].name = individual.name
            Memberdata.members[index].grade = individual.grade
            Memberdata.members = Memberdata.members
            print(Memberdata.members[index])
            // 他のフィールドも必要なら更新
            } else {
                print("見つかりませんでした")
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
