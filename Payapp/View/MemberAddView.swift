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
    
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var isDuplicate = false
    
    var body: some View {
        VStack(alignment: .leading){
            Form {
                //名前読み取り
                Section("名前") {
                    TextField("Name", text: $newMember.name)
                }
                //学年
                Section(
                    header: Text(group.Status.isEmpty ? "学年・所属ステータス" : "\(group.Status)"),
                    footer: Text(group.Status.isEmpty ? "学年・所属ステータスは空欄でも大丈夫です。" : "\(group.Status)は空欄でも大丈夫です。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                ) {
                    TextField("例：1年、卒業生など", text: $newMember.grade)
                }
            }
        }
        .onAppear{
            newMember.paymentStatus = listData.paylistitem
        }
        
        .toolbar{
            ToolbarItem{
                Button("完了"){
                    if newMember.name.isEmpty {
                        showAlert = true
                        isDuplicate = false
                    } else if Memberdata.members.contains(where: { $0.name == newMember.name }) {
                        isDuplicate = true
                        showAlert = true
                    } else {
                        Memberdata.members.append(newMember)
                        memberfireadd()
                        dismiss()
                    }
                }
                .alert(isPresented: $showAlert) {
                    if isDuplicate {
                        return Alert(
                            title: Text("確認"),
                            message: Text("すでに登録されている名前です。追加しますか？"),
                            primaryButton: .default(Text("追加する")) {
                                Memberdata.members.append(newMember)
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
        

        
