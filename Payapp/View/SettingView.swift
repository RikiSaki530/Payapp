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
            List{
                NavigationLink("アカウント削除"){
                    DeleteAccountView()
                }
                
                NavigationLink("グループリストに戻る"){
                    GroupListView(existingUser : $user)
                }
            }
        }
    }
}

struct SettingView_PreView : PreviewProvider{
    static var previews: some View{
        @State var user = User(name : "" ,Mailaddress: "", Password: "", admin: [:], groupList : [], UserID: 0)
        SettingView(user: $user)
    }
}
