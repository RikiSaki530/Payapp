//
//  LoginView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

import SwiftUI
import FirebaseAuth

//LoginView

struct LoginView: View {
    
    @State var ExistingUser = User(name: "", Mailaddress: "", Password: "", admin: [:],  groupList : [], UserID: 0)
    
    var body: some View {
        
        NavigationStack{
        
            VStack(spacing : 30){
                
                TextField("メールアドレス" , text: $ExistingUser.Mailaddress)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                TextField("パスワード" , text: $ExistingUser.Password)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                NavigationLink("ログイン"){
                    GroupListView(existingUser : $ExistingUser)
                }
                .colorMultiply(.black)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
            }
        }
    }
}

struct LogicalView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
