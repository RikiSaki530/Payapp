//
//  GroupCreationView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/04/30.
//

//グループを作る画面

import SwiftUI

struct GroupCreationView: View {
    
    @Binding var user : User
    
    var body: some View {
     
        NavigationStack{
            
            VStack(spacing : 30){
                
                //TextField("")
                
                NavigationLink("グループを作成"){                    ContentView(user:$user)
                }
                .foregroundColor(.black)
                .frame(width: 300 , height: 60)
                .background(Color.mint)
                .cornerRadius(15)
            }
            
        }
    }
}

struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
        
        GroupCreationView(user: $newUser)
    }
}
