//
//  StatusChangeView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/06/12.
//
import SwiftUI
import FirebaseFirestore

struct StatusChangeView: View {
    
    @ObservedObject var group: GroupData
    
    @State private var Status: String = ""
    
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        Form{
            Section{
                TextField("所属ステータス(例：学年、部署など)" , text: $Status)
            }
            
            Section{
                Text("ここで設定した名称は、各メンバーの支払い情報に表示されるステータスラベルになります。")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完了") {
                    updateStatus()
                    dismiss()
                }
            }
        }
    }
    
    func updateStatus(){
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        docRef.updateData([
            "Status": Status
        ]){ error in
            if let error = error {
                print("更新エラー: \(error.localizedDescription)")
            } else {
                print("PayListAddView:データを更新しました")
            }
        }
    }
}
