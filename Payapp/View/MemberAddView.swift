//
//  MemberAddView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/24.
//

import SwiftUI
import FirebaseFirestore

struct MemberAddView : View{
    
    @Binding var group : GroupData
    
    @EnvironmentObject var Memberdata :  MemberList
    @EnvironmentObject var listData : PayList
    
    @State var newMember : ClubMember = ClubMember(name: "", grade: "", schoolnumber: "" , paymentStatus:[])
    
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
                //学籍番号
                Section("学籍番号"){
                    TextField("schoolnuber" , text: $newMember.schoolnumber)
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
                        dismiss()
                    }
                }
            }
        }
        
    }
    
    func checkGroupExistence() {
        let db = Firestore.firestore()
        
        db.collection("Group").document(group.groupCode).getDocument { document, error in
            if let error = error {
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            group.groupFireChange() // 変更処理を呼び出す
            
        }
    }
    
}
    

