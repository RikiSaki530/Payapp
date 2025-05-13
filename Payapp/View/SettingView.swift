//
//  SettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//
import SwiftUI
import FirebaseAuth

struct SettingView: View {
    
    @ObservedObject var user :User
    
    
    var body: some View {
        
        NavigationStack{
            List{
                NavigationLink("アカウント削除"){
                    DeleteAccountView()
                }
                
                NavigationLink("グループリストに戻る"){
                    GroupListView(existingUser : user)
                }
                Button("ログアウト") {
                    logout()
                }
            }
        }
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("ログアウト成功")
        } catch let error {
            print("ログアウト失敗: \(error.localizedDescription)")
        }
    }
}

