//
//  NameSettingView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI

struct NameSettingView: View {
    
    @Binding var newUser : User
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 30){
                TextField("名前を入力" , text: $newUser.name)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                NavigationLink("OK"){
                    GroupselectView(user: $newUser)
                }
                .foregroundColor(.black)
                .frame(width: 75 , height: 50)
                .background(Color.yellow)
                .cornerRadius(10)
            }
            
        }
    }
}


struct NameSettingView1_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:], groupList : [], UserID: 0)
        
        NameSettingView(newUser: $newUser)
    }
}
