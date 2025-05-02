//
//  GroupselectView.swift
//  Payapp
//
//  Created by 崎原利生 on 2025/05/01.
//

//グループを作るか入るか選択

import SwiftUI

struct GroupselectView: View {
    
    @Binding var user : User
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                Spacer()
                    .frame(height : 40)
                
                NavigationLink("グループを作成"){
                    GroupCreationView(user: $user)
                }
                    .colorMultiply(.black)
                    .frame(width: 300 , height: 60)
                    .background(Color.yellow)
                    .cornerRadius(10)
                
                Spacer()
                    .frame(height : 40)
                
                NavigationLink("グループに参加"){
                    GroupJoinView(user : $user)
                }
                .colorMultiply(.black)
                .frame(width: 300 , height: 60)
                .background(Color.mint)
                .cornerRadius(10)
                
            }
        }
    }
}

struct GroupselectView_Previews: PreviewProvider {
    static var previews: some View {
        @State var newUser = User(name : "" ,Mailaddress: "", Password: "", admin: false, leader: false, groupList : [], UserID: 0)
        
        GroupselectView(user: $newUser)
    }
}
