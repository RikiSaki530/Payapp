//
//  SettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//

/**
 画面遷移よう研究
 */

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingView: View {
    
    @ObservedObject var user :User
    @ObservedObject var group : GroupData
    
    @State private var showConfirmation = false
    @State private var shouldNavigate = false
    @State private var shouldNavigate2 = false
    @State private var showPasswordPrompt = false
    
    @State private var delteAlert = false
    @State private var deleteAlertMessage : String = ""
    
    @Binding var path: NavigationPath
    
    var body: some View {
        
        List{
            
            if user.UserID == group.Leader[user.name]{
                Section{
                    NavigationLink("リーダーを変更"){
                        LeadechangeView(user : user , group : group)
                    }
                }
            }
            
            Button {
                path = NavigationPath()  // まずスタックを空にリセット
            } label: {
                Text("グループリストに戻る")
            }
            
            NavigationLink(value : Destination.StatusChange(group:group)){
                Text("所属ステータスを設定")
            }
            
            NavigationLink(value : Destination.Accoutndelete(user: user, group: group)){
                Text("アカウント削除")
            }
            
            Button("グループから抜ける") {
                showConfirmation = true // ✅ 確認アラートを表示
            }
            .foregroundColor(.red)
            .alert("本当にグループから抜けますか？", isPresented: $showConfirmation) {
                Button("キャンセル", role: .cancel) {}
                Button("OK", role: .destructive) {
                    GroupLogout {
                        path = NavigationPath()
                    }
                }
            }
            
            Button("ログアウト") {
                logout()
                path = NavigationPath()
            }
            .foregroundColor(.red)
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")
            
            user.reset()
            group.reset()
            
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userName")
            
        } catch let error {
            print("ログアウト失敗: \(error.localizedDescription)")
        }
    }
    
    func GroupLogout(completion: @escaping () -> Void) {
        user.groupList.removeValue(forKey: group.groupName)
        user.admin.removeValue(forKey: group.groupCode)
        group.AccountMemberList.removeValue(forKey: user.name)
        
        updateAccountMemberList {
            if group.AccountMemberList.isEmpty {
                deletegroup {
                    updateGroupList {
                        completion()
                    }
                }
            }else{
                updateGroupList {
                    completion() // ✅ Firestoreの両方の更新が完了してから呼ぶ
                }
            }
        }
    }
    
    
    func updateAccountMemberList(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("Group").document(group.groupCode)
        
        
        docRef.updateData([
            "AccountMemberList": group.AccountMemberList
        ]) { error in
            if let error = error {
                print("AccountMemberListの更新失敗: \(error.localizedDescription)")
            } else {
                print("AccountMemberListの更新成功")
            }
        }
        completion()
    }
    
    
    func updateGroupList(completion: @escaping () -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("User").document(user.UserID)
        
        docRef.updateData([
            "groupList": user.groupList,
            "admin" : user.admin
        ]) { error in
            if let error = error {
                print("groupListの更新失敗: \(error.localizedDescription)")
            } else {
                print("groupListの更新成功")
            }
        }
        completion()
    }
    
    func deletegroup(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("Group").document(group.groupCode).delete { error in
            if let error = error {
                print("Firestoreのグループ削除失敗: \(error.localizedDescription)")
            } else {
                print("Firestoreのグループ削除成功")
            }
            // 削除処理が終わってから completion を呼ぶ
            completion()
        }
    }
}


