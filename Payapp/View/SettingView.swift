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
    
    
    var body: some View {
        
        NavigationStack{
            List{
                
                if user.UserID == group.Leader[user.name]{
                    Section{
                        NavigationLink("リーダーを変更"){
                            LeadechangeView(user : user , group : group)
                        }
                    }
                }
                
                NavigationLink("グループリストに戻る"){
                    GroupListView(existingUser : user)
                }
                
                NavigationLink("アカウント削除"){
                    AccountDeleteView(user : user , group : group)
                }
                
                Button("グループから抜ける") {
                    showConfirmation = true // ✅ 確認アラートを表示
                }
                .foregroundColor(.red)
                .alert("本当にグループから抜けますか？", isPresented: $showConfirmation) {
                    Button("キャンセル", role: .cancel) {}
                    Button("OK", role: .destructive) {
                        GroupLogout {
                            shouldNavigate = true
                        }
                    }
                }
        
                Button("ログアウト") {
                    logout()
                    shouldNavigate2 = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            GroupListView(existingUser: user)
        }
        
        .navigationDestination(isPresented: $shouldNavigate2){
            OpneUIView()
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
            updateGroupList {
                completion() // ✅ Firestoreの両方の更新が完了してから呼ぶ
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
    
}


