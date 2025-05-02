//
//  SettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//
import SwiftUI

struct SettingView: View {
    
    @Binding var user :User
    
    var body: some View {
        
        NavigationStack{
            
            NavigationLink("アカウント削除"){
                DeleteAccountView()
            }
            .colorMultiply(.black)
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            
            
            NavigationLink("グループリストに戻る"){
                GroupListView(existingUser : $user)
            }
            .colorMultiply(.black)
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
        }
    }
}
