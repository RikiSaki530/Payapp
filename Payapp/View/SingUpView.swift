//
//  Untitled 3.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/02.
//

import SwiftUI

struct SingUpView : View {
    
    @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: [:], groupList : [], UserID: 0)
    
    var body : some View {
        NavigationStack{
            VStack(spacing: 30){
                
                TextField("メールアドレス", text: $newUser.Mailaddress)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                TextField("パスワード" , text: $newUser.Password)
                    .frame(width: 300)
                    .textFieldStyle(.roundedBorder)
                
                
                NavigationLink("OK"){
                    NameSettingView(newUser: $newUser)
                }
                .colorMultiply(.black)
                .frame(width: 75 , height: 45)
                .background(Color.yellow)
                .cornerRadius(10)
            }
            
        }
    }

}


struct SingUppersView_Previews : PreviewProvider {
    static var previews: some View {
        SingUpView()
    }
}

