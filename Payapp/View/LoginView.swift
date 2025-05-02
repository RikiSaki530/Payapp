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
    
    @State var ExistingUser = User(name: "", Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
    
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink("ログイン"){
                    GroupListView(existingUser: $ExistingUser)
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
